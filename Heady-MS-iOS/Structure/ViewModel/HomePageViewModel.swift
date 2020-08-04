//
//  HomePageViewModel.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 03/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

//MARK:- View Model Delegate
protocol HomePageViewModelDelegate: class {
      
      /**
       Delegate method is used to parse data in view controller.
       
       - Parameter categories: Returns response of Category Data in delegate method
       - Parameter type: Returns response of Product Data in delegate method
       - Parameter isCacheData: Returns boolean value whether data from cache or fresh in delegate method
       - Parameter success: Return success or failure status in delegate method
       - Parameter isCacheData: Returns error message in delegate method
       */
      func didReceiveCategoriesData(categories: [CategoryData], products: [ProductData], isCacheData: Bool, success: Bool, error: String?)
}

final class HomePageViewModel {
      
      weak var homePageDelegate: HomePageViewModelDelegate?
      
      var arrCategoryData = [CategoryData]()
      var arrProductsData = [ProductData]()
      
      //MARK:- Fetch New ECommerce Data
      func fetchECommerceData() {
            
            let networking = APINetworking()
            networking.performNetworkRequest(reqEndpoint: APIConstants.productList(), type: MainRootData.self) { (status, response, error) in
                  
                  var strErrorMessage = ""
                  if status {
                        
                        //Parse Category & Ranking Data
                        if let categories = response?.categories, let rankings = response?.rankings {
                              
                              self.arrCategoryData = self.parseResponsData(categories: categories, rankings: rankings)
                              
                              //Store Data in Cache
                              self.storeCategoriesDataInLocalCache(categories: self.arrCategoryData)
                              self.storeProductsDataInLocalCache(products: self.arrProductsData)
                        }
                        else {
                              strErrorMessage = "No more categories are available."
                        }
                  }
                  else {
                        strErrorMessage = error?.localizedDescription ?? ""
                  }
                  
                  //Delegate
                  if let delegate = self.homePageDelegate {
                        delegate.didReceiveCategoriesData(categories: self.arrCategoryData, products: self.arrProductsData, isCacheData: false, success: status, error: strErrorMessage)
                  }
            }
      }
      
      /**
       Parse Main Data to Categories & Products Data
       
       - Parameter categories: Category Data Response of API
       - Parameter rankings: Ranking Data Response of API
       
       - Returns: Categories in structured manner including related sub-categories & products.
       */
      func parseResponsData(categories: [CategoryData], rankings: [RankingData]) -> [CategoryData] {
            
            var arrResultCategories = [CategoryData]()
            
            //Ranking Data
            var dictRanking = [String : Dictionary<Int, Int>]()
            if rankings.count > 0 {
                  
                  for rank in rankings {
                        var title = rank.ranking!
                        var dictProduct = [Int : Int]()
                        for product in rank.products! {
                              
                              if title.lowercased().contains("view") {
                                    dictProduct[product.id!] = product.view_count ?? 0
                                    title = "view"
                              }
                              else if title.lowercased().contains("order") {
                                    dictProduct[product.id!] = product.order_count ?? 0
                                    title = "order"
                              }
                              else if title.lowercased().contains("share") {
                                    dictProduct[product.id!] = product.shares ?? 0
                                    title = "share"
                              }
                        }
                        dictRanking[title] = dictProduct
                  }
            }
            
            //Categories Data
            if categories.count > 0 {
                  
                  arrResultCategories.removeAll()
                  var addedCategories = [Int]()
                  
                  let arrMainCategories = categories.filter { $0.child_categories?.count ?? 0 > 0 }
                  for cat in arrMainCategories {
                        
                        if !addedCategories.contains(cat.id ?? 0) {
                              
                              let resultCategory = self.populateData(categories: categories, currentCategory: cat, dictRanks: dictRanking)
                              arrResultCategories.append(resultCategory.resCategory)
                              
                              for id in resultCategory.addedCat {
                                    addedCategories.append(id)
                              }
                        }
                  }
            }
            return arrResultCategories
      }
      
      //MARK:- Populate Data into Categories & Products
      /**
       Parse Category Data & Categorised them into sub-category & products, also include product ranking.
       
       - Parameter categories: All Category Data
       - Parameter currentCategory: Current Category Data
       - Parameter dictRanks: Ranking Data in Dictionary
       
       - Returns: Returns Result Category including it's child sub-categories & products.
       */
      func populateData(categories: [CategoryData], currentCategory: CategoryData, dictRanks: Dictionary<String, Dictionary<Int, Int>>) -> (resCategory: CategoryData, addedCat: [Int]) {
            
            var alreadyAddedIds = [Int]()
            var category = currentCategory
            
            if let subCategories = currentCategory.child_categories {
                  
                  category.sub_categories = [CategoryData]()
                  for id in subCategories {
                        
                        let subCat = categories.filter { $0.id ?? 0 == id }.first
                        if subCat != nil {
                              
                              let subSubCat = populateData(categories: categories, currentCategory: subCat!, dictRanks: dictRanks)
                              category.sub_categories?.append(subSubCat.resCategory)
                              
                              for id in subSubCat.addedCat {
                                    alreadyAddedIds.append(id)
                              }
                        }
                  }
                  
                  //Products
                  if category.products != nil {
                        
                        var products = [ProductData]()
                        for var product in category.products!  {
                              
                              if let dictRankView = dictRanks["view"] {
                                    if dictRankView.keys.contains(product.id ?? 0) {
                                          product.view_count = dictRankView[product.id!]
                                    }
                              }
                              
                              if let dictRankOrder = dictRanks["order"] {
                                    if dictRankOrder.keys.contains(product.id ?? 0) {
                                          product.order_count = dictRankOrder[product.id!]
                                    }
                              }
                              
                              if let dictRankShare = dictRanks["share"] {
                                    if dictRankShare.keys.contains(product.id ?? 0) {
                                          product.shares = dictRankShare[product.id!]
                                    }
                              }
                              products.append(product)
                              self.arrProductsData.append(product)
                        }
                        category.products = products
                  }
            }
            alreadyAddedIds.append(category.id ?? 0)
            return (category, alreadyAddedIds)
      }
      
      //Store them into Defaults
      /**
       Store categories data into Local cache to use in offline mode.
       
       - Parameter categories: Category Data
       */
      func storeCategoriesDataInLocalCache(categories: [CategoryData]) {
            
            let encoder = JSONEncoder()
            if let encodedValue = try? encoder.encode(categories) {
                  let defaults = UserDefaults.standard
                  defaults.set(encodedValue, forKey: "Heady_Categories")
                  defaults.synchronize()
            }
      }
      
      /**
       Store products data into Local cache to use in offline mode.
       
       - Parameter products: Product Data
       */
      func storeProductsDataInLocalCache(products: [ProductData]) {
            
            let encoder = JSONEncoder()
            if let encodedValue = try? encoder.encode(products) {
                  let defaults = UserDefaults.standard
                  defaults.set(encodedValue, forKey: "Heady_Products")
                  defaults.synchronize()
            }
      }
      
      //MARK:- Fetch Local Categories & Products Data
      /**
       Fetch categories & products data from Local cache to use on Home page.
       
       - Returns: Returns Result Category including it's child sub-categories & products.
       */
      func fetchLocalData() {
            
            var status = false
            var strErrorMessage = ""
            
            let defaults = UserDefaults.standard
            if let cacheCategories = defaults.object(forKey: "Heady_Categories") as? Data {
                  
                  let decoder = JSONDecoder()
                  if let categories = try? decoder.decode([CategoryData].self, from: cacheCategories) {
                        
                        for category in categories {
                              self.arrCategoryData.append(category)
                        }
                        status = true
                  }
                  else {
                        strErrorMessage = "No more categories are available."
                  }
            }
            else {
                  strErrorMessage = "No more local categories are available."
            }
            
            if let cacheProducts = defaults.object(forKey: "Heady_Products") as? Data {
                  
                  let decoder = JSONDecoder()
                  if let products = try? decoder.decode([ProductData].self, from: cacheProducts) {
                        
                        for product in products {
                              self.arrProductsData.append(product)
                        }
                        status = true
                  }
                  else {
                        strErrorMessage = "No more categories are available."
                  }
            }
            else {
                  strErrorMessage = "No more local categories are available."
            }
            
            //Delegate
            if let delegate = self.homePageDelegate {
                  delegate.didReceiveCategoriesData(categories: self.arrCategoryData, products: self.arrProductsData, isCacheData: true, success: status, error: strErrorMessage)
            }
      }
}
