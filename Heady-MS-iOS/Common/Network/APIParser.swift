//
//  APIParser.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

protocol Networking {
      
      //MARK: Completion Handler
      /**
       Completion Handler method will be used in network request.
       
       - Parameter status: Returns success or failure in closure
       - Parameter respoonse: Returns Response Data in closure
       - Parameter message: Returns success or failure message in closure
       
       - Returns: Returns network data response in closure.
       */
      typealias completionDataHandler<T> = (_ status: Bool, _ response: T?, _ errorMessage: Error?) -> Void
      
      /**
       Creates a network request to fetch data from API.
       
       - Parameter reqEndpoint: API Endpoint
       - Parameter type: Response Class type
       - Parameter completion: Completion block will be used to fetch value
       
       - Returns: Returns network data response in closure.
       */
      func performNetworkRequest<T: Codable>(reqEndpoint: APIConstants, type: T.Type, completion: @escaping completionDataHandler<T>)
}

struct APINetworking: Networking {
      
      //MARK:- Perform Network Request
      func performNetworkRequest<T: Codable>(reqEndpoint: APIConstants, type: T.Type, completion: @escaping completionDataHandler<T>) {
            
            let urlString = APIServerConstants.serverBaseURL.appendingPathComponent(reqEndpoint.path).absoluteString.removingPercentEncoding
            guard let reqURL = URL(string: urlString ?? "") else {
                  let error = APICustomError(title: "URL Error", desc: "URL is invalid.", code: 0, api: urlString ?? "")
                  completion(false, nil, error)
                  return
            }
            
            var urlRequest = URLRequest(url: reqURL)
            urlRequest.timeoutInterval = APIServerConstants.serverTimeout
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            urlRequest.httpMethod = reqEndpoint.reqType
            
            let urlSession = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
                  
                  guard let responseCode = urlResponse as? HTTPURLResponse else {
                        let error = APICustomError(title: "Server Error", desc: "Something went wrong.", code: 0, api: urlString ?? "")
                        completion(false, nil, error)
                        return
                  }
                  
                  if responseCode.statusCode != 200 {
                        let error = APICustomError(title: "Server Error", code: responseCode.statusCode, api: urlString ?? "")
                        completion(false, nil, error)
                        return
                  }
                  
                  guard let responseType = urlResponse?.mimeType, responseType == "application/json" else {
                        let error = APICustomError(title: "Server Error", desc: "Invalid JSON.", code: 0, api: urlString ?? "")
                        completion(false, nil, error)
                        return
                  }
                  
                  if let err = error {
                        let error = APICustomError(title: "Data not found", desc: err.localizedDescription, code: 200, api: urlString ?? "")
                        completion(false, nil, error)
                        return
                  }
                  
                  guard let data = data else {
                        let error = APICustomError(title: "Data not found", desc: "Data not found", code: 200, api: urlString ?? "")
                        completion(false, nil, error)
                        return
                  }
                  
                  let response = ResponseData(data: data)
                  let decodedResponse = response.decode(type)
                  
                  guard let decodedData = decodedResponse.decodedData else {
                        
                        if let err = decodedResponse.error {
                              let error = APICustomError(title: "Data not decoded", desc: err.localizedDescription, code: 200, api: urlString ?? "")
                              completion(false, nil, error)
                              return
                        }
                        completion(false, nil, nil)
                        return
                  }
                  
                  //MARK: Valid Response
                  completion(true, decodedData, nil)
            }
            urlSession.resume()
      }
}
