//
//  ProductListVC.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

class ProductListVC: UICollectionViewController {
      
      var arrProducts = [ProductData]()
      var selectedIndex = 0
      
      //MARK:- Class Methods
      override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            
            self.collectionView.isAccessibilityElement = true
            self.collectionView.accessibilityIdentifier = "idProductCollection"
      }
      
      //MARK:- Collection View Methods
      override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrProducts.count
      }
      
      override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
                  
                  cell.isAccessibilityElement = false
                  cell.accessibilityIdentifier = String(format: "idProductCollection_%d_%d", indexPath.section, indexPath.item)
                  
                  let product = self.arrProducts[indexPath.row]
                  cell.lblProductName.text = product.name ?? ""
                  cell.lblProductPrice.text = "₹\(product.variants![0].price ?? 0)"
                  cell.imgProduct.backgroundColor = UIColor.random(alpha: 0.8)
                  
                  switch self.selectedIndex {
                  case 3:
                        cell.lblProductViews.text = "\(product.order_count ?? 0) orders"
                        break
                  case 4:
                        cell.lblProductViews.text = "\(product.shares ?? 0) shares"
                        break
                  default:
                        cell.lblProductViews.text = "\(product.view_count ?? 0) views"
                        break
                  }
                  
                  cell.contentView.layer.borderColor = UIColor.black.cgColor
                  cell.contentView.layer.borderWidth = 0.2
                  cell.contentView.layer.cornerRadius = 5.0
                  return cell
            }
            return ProductCell()
      }
      
      override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let productsDetails = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idProductDetailsVC") as! ProductDetailsVC
            productsDetails.objProductData = self.arrProducts[indexPath.item]
            self.navigationController?.pushViewController(productsDetails, animated: true)
      }
}

//MARK:- Collection View Flow Layout
extension ProductListVC: UICollectionViewDelegateFlowLayout {
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let itemsPerRow: CGFloat = 2
            let hardCodedPadding: CGFloat = 10
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            return CGSize(width: itemWidth, height: 240)
      }
}

//MARK:- Product Cell
class ProductCell: UICollectionViewCell {
      
      @IBOutlet weak var imgProduct: UIImageView!
      @IBOutlet weak var lblProductName: UILabel!
      
      @IBOutlet weak var lblProductPrice: UILabel!
      @IBOutlet weak var lblProductViews: UILabel!
}
