//
//  APIConstants.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import Foundation

struct APIServerConstants {
      
      static let serverBaseURL = URL(string: "https://stark-spire-93433.herokuapp.com")!
      static let serverTimeout = 30.0
}

protocol Endpoint {
      
      var path: String { get }
      var reqType: String { get }
}

enum APIConstants {
      
      case productList()
}

extension APIConstants: Endpoint {
      
      var path: String {
            switch self {
            case .productList():
                  return "/json"
            }
      }
      
      var reqType: String {
            switch self {
            case .productList():
                  return "GET"
            }
      }
}
