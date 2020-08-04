//
//  Heady_MS_iOSUITests.swift
//  Heady-MS-iOSUITests
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import XCTest

class Heady_MS_iOSUITests: XCTestCase {
      
      private var app: XCUIApplication!
      
      override func setUp() {
            
            continueAfterFailure = false
            app = XCUIApplication()
            app.launch()
      }
      
      override func tearDown() {
            
      }
      
      /**
       Test function is used to check category cell exists on Home Page.
       */
      func testForHomePageCellExistence() {
            
            sleep(1)
            let tblHome = app.tables.matching(identifier: "idHomeTable")
            let cellHome = tblHome.cells.element(matching: .cell, identifier: "idHomeTable_1_0")
            let existencePredicate = NSPredicate(format: "exists == 1")
            let expectationEval = expectation(for: existencePredicate, evaluatedWith: cellHome, handler: nil)
            let waiterHome = XCTWaiter.wait(for: [expectationEval], timeout: 10.0)
            XCTAssert(XCTWaiter.Result.completed == waiterHome, "No Category Cell is available on Home Page.")
      }
      
      /**
       Test function is used to check navigation flow upto Product List Page.
       */
      func testToNavigateToProductListPage() {
            
            //Open Application & Launch Home Page
            sleep(1)
            let tblHome = app.tables.matching(identifier: "idHomeTable")
            let cellHome = tblHome.cells.element(matching: .cell, identifier: "idHomeTable_1_0")
            let predicateHome = NSPredicate(format: "isHittable == true")
            let expectationEvalHome = expectation(for: predicateHome, evaluatedWith: cellHome, handler: nil)
            let waiterHome = XCTWaiter.wait(for: [expectationEvalHome], timeout: 10.0)
            XCTAssert(XCTWaiter.Result.completed == waiterHome, "No Category is available on Home Page.")
            
            //Navigate to Sub-Categories List Page
            cellHome.tap()
            sleep(1)
            let tblCat = app.tables.matching(identifier: "idCategoryTable")
            let cellCat = tblCat.cells.element(matching: .cell, identifier: "idCategoryTable_0_0")
            let predicateCat = NSPredicate(format: "isHittable == true")
            let expectationEvalCat = expectation(for: predicateCat, evaluatedWith: cellCat, handler: nil)
            let waiterCat = XCTWaiter.wait(for: [expectationEvalCat], timeout: 10.0)
            XCTAssert(XCTWaiter.Result.completed == waiterCat, "No Sub-Category is available on Home Page.")
            
            //Navigate to Products List Page
            cellCat.tap()
            sleep(2)
      }
}
