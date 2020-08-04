//
//  Heady_MS_iOSTests.swift
//  Heady-MS-iOSTests
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import XCTest
@testable import Heady_MS_iOS

class Heady_MS_iOSTests: XCTestCase {
      
      var arrCategoryData: [CategoryData]!
      
      override func setUp() {
            
            //Load Stub - Demo JSON file
            let data = loadStub(name: "Ecommerce", extension: "json")
            let decoder = JSONDecoder()
            
            do {
                  let mainRootData = try decoder.decode(MainRootData.self, from: data)
                  
                  //Initialize View Model
                  let viewModel = HomePageViewModel()
                  self.arrCategoryData = viewModel.parseResponsData(categories: mainRootData.categories!, rankings: mainRootData.rankings!)
            }
            catch {
                  XCTFail(error.localizedDescription)
            }
      }
      
      override func tearDown() {
            
      }
      
      /**
       Test Function is used to check parent category data.
       */
      func testParentCategoryData() {
            
            XCTAssertEqual(self.arrCategoryData[0].name!, "Mens Wear")
            XCTAssertEqual(self.arrCategoryData[0].sub_categories!.count, 1)
      }
      
      /**
       Test Function is used to check sub category data.
       */
      func testSubCategoryData() {
            
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].name!, "Foot Wear")
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories!.count, 2)
      }
      
      /**
       Test Function is used to check product data.
       */
      func testProductData() {
            
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories![0].name!, " Casuals")
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories![0].products!.count, 2)
      }
      
      /**
       Test Function is used to check product details data.
       */
      func testProductDetailsData() {
            
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories![0].name!, " Casuals")
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories![0].products![0].name!, "Nike Sneakers")
            
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories![0].products![0].view_count!, 56700)
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories![0].products![0].order_count!, 5600)
            XCTAssertEqual(self.arrCategoryData[0].sub_categories![0].sub_categories![0].products![0].shares!, 1800)
      }
}

extension XCTestCase {
      
      /**
       This function is used to load Stub Data from JSON file.
       
       - Parameter name: File Name.
       - Parameter extension: File extension.
       
       - Returns: It will return data from JSON file.
       */
      func loadStub(name: String, extension: String) -> Data {
            
            let bundle = Bundle(for: type(of: self))
            let url = bundle.url(forResource: name, withExtension: `extension`)
            return try! Data(contentsOf: url!)
      }
}
