//
//  CategoryData.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

struct CategoryData: Codable {
      
      var id: Int?
      var name: String?
      var products: [ProductData]?
      var child_categories: [Int]?
      var sub_categories: [CategoryData]?
}
