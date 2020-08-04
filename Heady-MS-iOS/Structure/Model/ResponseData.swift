//
//  ResponseData.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

struct ResponseData {
      
      fileprivate var resData: Data
      init(data: Data) {
            self.resData = data
      }
}

extension ResponseData {
      
      /**
       Decode JSON Data & convert into Codable structure data
       
       - Parameter type: Codable Class Type
       
       - Returns: Returns Decoded data & error message in closure.
       */

      public func decode<T: Codable>(_ type: T.Type) -> (decodedData: T?, error: Error?) {
            
            let jsonDecoder = JSONDecoder()
            do {
                  let response = try jsonDecoder.decode(T.self, from: resData)
                  return (response, nil)
            }
            catch let error {
                  return (nil, error)
            }
      }
}
