//
//  CategoryListVC.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

class CategoryListVC: UITableViewController {
      
      var subCategoryData = [CategoryData]()
      
      //MARK:- Class Methods
      override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            
            self.tableView.isAccessibilityElement = true
            self.tableView.accessibilityIdentifier = "idCategoryTable"
      }
      
      //MARK:- Table View Methods
      override func numberOfSections(in tableView: UITableView) -> Int {
            return subCategoryData.count
      }
      
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return subCategoryData[section].child_categories?.count ?? 0
      }
      
      override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return subCategoryData[section].name ?? "'"
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell") as! SubCategoryCell
            cell.isAccessibilityElement = true
            cell.accessibilityIdentifier = String(format: "idCategoryTable_%d_%d", indexPath.section, indexPath.row)
            
            let subSubCategories = self.subCategoryData[indexPath.section].sub_categories![indexPath.row]
            cell.lblCategoryName.text = subSubCategories.name ?? ""
            return cell
      }
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let productsData = self.subCategoryData[indexPath.section].sub_categories![indexPath.row].products, productsData.count > 0 {
                  let products = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idProductListVC") as! ProductListVC
                  products.arrProducts  = productsData
                  self.navigationController?.pushViewController(products, animated: true)
            }
      }
}

//MARK:- Sub-Category Cell
class SubCategoryCell: UITableViewCell {
      
      @IBOutlet weak var lblCategoryName: UILabel!
}
