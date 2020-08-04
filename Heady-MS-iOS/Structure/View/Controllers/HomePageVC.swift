//
//  HomePageVC.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

class HomePageVC: UITableViewController {
      
      private var arrCategories: [CategoryData] = [CategoryData]()
      
      private var arrProductsByViews = [ProductData]()
      private var arrProductsByOrders = [ProductData]()
      private var arrProductsByShares = [ProductData]()
      
      private var viewModel: HomePageViewModel = HomePageViewModel()
      
      //MARK:- Class Methods
      override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.tableFooterView = UIView.init()
            
            self.tableView.isAccessibilityElement = true
            self.tableView.accessibilityIdentifier = "idHomeTable"
            
            self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching new categories & products...")
            self.tableView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
            
            self.viewModel.homePageDelegate = self
            self.loadECommerceData()
      }
      
      //Load ECommerce Data
      func loadECommerceData() {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.viewModel.fetchLocalData()
      }
      
      /**
       Function is used to fetch new refreshed data from server.
       
       - Parameter sender: Tableview Object
       */
      @objc func refresh(sender: AnyObject) {
            
            //Check Internet Connectivity
            if Reachability.isConnectedToNetwork() {
                  UIApplication.shared.isNetworkActivityIndicatorVisible = true
                  self.viewModel.fetchECommerceData()
            }
            else {
                  let alertVC = UIAlertController.init(title: "Heady E-Commerce", message: "Internet Connection is not available. Please try again!", preferredStyle: .alert)
                  let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                  alertVC.addAction(actionOk)
                  self.present(alertVC, animated: true, completion: nil)
            }
      }
}

//MARK:- Delegate Method
extension HomePageVC: HomePageViewModelDelegate {
      
      func didReceiveCategoriesData(categories: [CategoryData], products: [ProductData], isCacheData: Bool, success: Bool, error: String?) {
            
            if success {
                  self.arrCategories = categories
                  
                  //Products will be in sorted form by views, orders & shares.
                  self.arrProductsByViews = products.sorted(by: { $0.view_count ?? 0 > $1.view_count ?? 0 })
                  self.arrProductsByOrders = products.sorted(by: { $0.order_count ?? 0 > $1.order_count ?? 0 })
                  self.arrProductsByShares = products.sorted(by: { $0.shares ?? 0 > $1.shares ?? 0 })
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                  }
            }
            else {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        let alertVC = UIAlertController.init(title: "Heady E-Commerce", message: error ?? "Something went wrong.", preferredStyle: .alert)
                        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertVC.addAction(actionOk)
                        self.present(alertVC, animated: true, completion: nil)
                  }
            }
            
            //Fetch Fresh Data
            if isCacheData {
                  
                  //Check Internet Connectivity
                  if Reachability.isConnectedToNetwork() {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        self.viewModel.fetchECommerceData()
                  }
                  else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                              let alertVC = UIAlertController.init(title: "Heady E-Commerce", message: "Internet Connection is not available. Please try again!", preferredStyle: .alert)
                              let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                              alertVC.addAction(actionOk)
                              self.present(alertVC, animated: true, completion: nil)
                        }
                  }
            }
      }
}

//MARK:- Table View Methods
extension HomePageVC {
      
      override func numberOfSections(in tableView: UITableView) -> Int {
            return 5
      }
      
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return section == 1 ? self.arrCategories.count : 1
      }
      
      override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            switch section {
            case 1:
                  return "Categories"
            case 2:
                  return "Most Viewed"
            case 3:
                  return "Most Ordered"
            case 4:
                  return "Most Shared"
            default:
                  return "Heady E-Commerce"
            }
      }
      
      override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40.0
      }
      
      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return section == 4 ? 20.0 : 0.0
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            switch indexPath.section {
            case 1:
                  let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
                  cell.isAccessibilityElement = true
                  cell.accessibilityIdentifier = String(format: "idHomeTable_%d_%d", indexPath.section, indexPath.row)
                  
                  let cat = self.arrCategories[indexPath.row]
                  cell.lblCategoryName.text = "\(cat.name ?? "")"
                  cell.imgCategoryImage.backgroundColor = UIColor.random(alpha: 0.8)
                  return cell
                  
            case 2, 3, 4:
                  let views = Array(self.arrProductsByViews.prefix(5))
                  let orders = Array(self.arrProductsByOrders.prefix(5))
                  let shares = Array(self.arrProductsByShares.prefix(5))
                  let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryRow") as! CategoryRow
                  cell.configureProducts(index: indexPath.section, views: views, orders: orders, shares: shares, delegate: self)
                  return cell
                  
            default:
                  let cell = tableView.dequeueReusableCell(withIdentifier: "BannerRow") as! BannerRow
                  return cell
            }
      }
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if indexPath.section == 1 {
                  
                  if let subCategoriesData = self.arrCategories[indexPath.row].sub_categories, subCategoriesData.count > 0 {
                        
                        let categories = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCategoryListVC") as! CategoryListVC
                        categories.subCategoryData = subCategoriesData
                        self.navigationController?.pushViewController(categories, animated: true)
                  }
            }
      }
}

//MARK:- Category Row Data - Delegate
extension HomePageVC: CategoryRowSelectionDelegate {
      
      func didClickOnProduct(productData: ProductData?, isViewAll: Bool?, selectedIndex: Int?) {
            
            if isViewAll! {
                  let products = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idProductListVC") as! ProductListVC
                  products.selectedIndex = selectedIndex!
                  switch selectedIndex! {
                  case 2:
                        products.arrProducts  = self.arrProductsByViews
                  case 3:
                        products.arrProducts  = self.arrProductsByOrders
                  case 4:
                        products.arrProducts  = self.arrProductsByShares
                  default:
                        break
                  }
                  self.navigationController?.pushViewController(products, animated: true)
            }
            else {
                  let productsDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idProductDetailsVC") as! ProductDetailsVC
                  productsDetails.objProductData = productData!
                  self.navigationController?.pushViewController(productsDetails, animated: true)
            }
      }
}

//MARK:- Category Cell
class CategoryCell: UITableViewCell {
      
      @IBOutlet weak var imgCategoryImage: UIImageView!
      @IBOutlet weak var lblCategoryName: UILabel!
}
