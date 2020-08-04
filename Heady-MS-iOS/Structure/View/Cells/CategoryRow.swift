//
//  CategoryRow.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

//MARK:- Category Product Selection Delegate
protocol CategoryRowSelectionDelegate {
      
      /**
       Delegate method to get current product from collection view.
       
       - Parameter productData: Returns Product Data object in delegate method.
       - Parameter isViewAll: Returns boolean value for view all functionality in delegate method.
       - Parameter selectedIndex: Returns index for selected product object in delegate method.
       */
      func didClickOnProduct(productData: ProductData?, isViewAll: Bool?, selectedIndex: Int?)
}

class CategoryRow: UITableViewCell {
      
      var rowIndex = 0
      var sortByViews = [ProductData]()
      var sortByOrders = [ProductData]()
      var sortByShares = [ProductData]()
      
      @IBOutlet weak var collectionView: UICollectionView!
      var delegateCategoryRow: CategoryRowSelectionDelegate?
      
      //MARK:- Class Methods
      /**
       Generate Collection view for most viewed, most ordered & most shared products.
       
       - Parameter index: Index of section
       - Parameter views: Numbers of most viewed products
       - Parameter orders: Numbers of most ordered products
       - Parameter shares: Numbers of most shared products
       - Parameter delegate: Set Delegate object which point to view controller
       */
      func configureProducts(index: Int, views: [ProductData], orders: [ProductData], shares: [ProductData], delegate: CategoryRowSelectionDelegate) {
            
            self.rowIndex = index
            self.delegateCategoryRow = delegate
            
            switch index {
            case 2:
                  self.sortByViews = views
                  break
            case 3:
                  self.sortByOrders = orders
                  break
            case 4:
                  self.sortByShares = shares
                  break
            default:
                  break
            }
            
            self.collectionView.reloadData()
      }
}

//MARK:- Collection View Methods
extension CategoryRow : UICollectionViewDataSource {
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            switch self.rowIndex {
            case 2:
                  return self.sortByViews.count > 0 ? self.sortByViews.count + 1 : 0
            case 3:
                  return self.sortByOrders.count > 0 ? self.sortByOrders.count + 1 : 0
            case 4:
                  return self.sortByShares.count > 0 ? self.sortByShares.count + 1 : 0
            default:
                  return 0
            }
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            var lastIndex = 0
            switch self.rowIndex {
            case 2:
                  lastIndex = self.sortByViews.count
                  break
            case 3:
                  lastIndex = self.sortByOrders.count
                  break
            case 4:
                  lastIndex = self.sortByShares.count
                  break
            default:
                  lastIndex = 0
                  break
            }
            
            //Cell
            if indexPath.item == lastIndex {
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllProductCell", for: indexPath) as! ViewAllProductCell
                  cell.lblViewAll.backgroundColor = UIColor.random(alpha: 0.2)
                  cell.lblViewAll.layer.borderColor = UIColor.black.cgColor
                  cell.lblViewAll.layer.borderWidth = 0.2
                  cell.lblViewAll.layer.cornerRadius = 40.0
                  cell.lblViewAll.clipsToBounds = true
                  return cell
            }
            else {
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryProductCell", for: indexPath) as! CategoryProductCell
                  var productData = ProductData()
                  switch self.rowIndex {
                  case 2:
                        productData = self.sortByViews[indexPath.item]
                        cell.lblProductViews.text = "\(productData.view_count ?? 0) views"
                        break
                  case 3:
                        productData = self.sortByOrders[indexPath.item]
                        cell.lblProductViews.text = "\(productData.order_count ?? 0) orders"
                        break
                  case 4:
                        productData = self.sortByShares[indexPath.item]
                        cell.lblProductViews.text = "\(productData.shares ?? 0) shares"
                        break
                  default:
                        productData = ProductData()
                        break
                  }
                  
                  cell.lblProductName.text = productData.name ?? ""
                  cell.imgProduct.backgroundColor = UIColor.random(alpha: 0.8)
                  cell.contentView.layer.borderColor = UIColor.black.cgColor
                  cell.contentView.layer.borderWidth = 0.2
                  cell.contentView.layer.cornerRadius = 5.0
                  return cell
            }
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            var lastIndex = 0
            switch self.rowIndex {
            case 2:
                  lastIndex = self.sortByViews.count
                  break
            case 3:
                  lastIndex = self.sortByOrders.count
                  break
            case 4:
                  lastIndex = self.sortByShares.count
                  break
            default:
                  lastIndex = 0
                  break
            }
            
            //Redirect to Product List or Details Page
            if let delegate = delegateCategoryRow {
                  
                  if indexPath.item == lastIndex {
                        delegate.didClickOnProduct(productData: nil, isViewAll: true, selectedIndex: self.rowIndex)
                  }
                  else {
                        switch self.rowIndex {
                        case 2:
                              delegate.didClickOnProduct(productData: self.sortByViews[indexPath.item], isViewAll: false, selectedIndex: self.rowIndex)
                              break
                        case 3:
                              delegate.didClickOnProduct(productData: self.sortByOrders[indexPath.item], isViewAll: false, selectedIndex: self.rowIndex)
                              break
                        case 4:
                              delegate.didClickOnProduct(productData: self.sortByShares[indexPath.item], isViewAll: false, selectedIndex: self.rowIndex)
                              break
                        default:
                              delegate.didClickOnProduct(productData: nil, isViewAll: true, selectedIndex: self.rowIndex)
                              break
                        }
                  }
            }
      }
}

//MARK:- Collection View Flow Layout
extension CategoryRow: UICollectionViewDelegateFlowLayout {
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let itemsPerRow: CGFloat = 3
            let hardCodedPadding: CGFloat = 5
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
            return CGSize(width: itemWidth, height: itemHeight)
      }
}

//MARK:- Category Product Cell
class CategoryProductCell: UICollectionViewCell {
      
      @IBOutlet weak var imgProduct: UIImageView!
      @IBOutlet weak var lblProductName: UILabel!
      @IBOutlet weak var lblProductViews: UILabel!
}

class ViewAllProductCell: UICollectionViewCell {
      
      @IBOutlet weak var lblViewAll: UILabel!
}
