//
//  ProductData.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import Foundation

struct VariantData: Codable {
      
      var id: Int?
      var color: String?
      var size: Int?
      var price: Int?
}

struct TaxData: Codable {
      
      var name: String?
      var value: Double?
}

struct ProductData: Codable {
      
      var id: Int?
      var name: String?
      var date_added: String?
      
      var variants: [VariantData]?
      var tax: TaxData?
      var view_count: Int?
      var order_count: Int?
      var shares: Int?
}
