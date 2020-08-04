//
//  ProductDetailsVC.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

class VariantCell: UICollectionViewCell {
      
      @IBOutlet weak var lblColor: UILabel!
      @IBOutlet weak var lblName: UILabel!
}

class ProductDetailsVC: UIViewController {
      
      var objProductData = ProductData()
      
      @IBOutlet weak var lblProductName: UILabel!
      @IBOutlet weak var imgProduct: UIImageView!
      @IBOutlet weak var lblProductPrice: UILabel!
      @IBOutlet weak var collectionVariants: UICollectionView!
      @IBOutlet weak var lblProductTaxLabel: UILabel!
      @IBOutlet weak var lblProductTaxValue: UILabel!
      @IBOutlet weak var btnAddToCart: UIButton!
      
      //MARK:- Class Methods
      override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            
            lblProductName.text = objProductData.name ?? "Product"
            lblProductPrice.text = "₹\(objProductData.variants![0].price ?? 0)"
            lblProductTaxLabel.text = objProductData.tax?.name ?? "TAX"
            lblProductTaxValue.text = "\(objProductData.tax?.value ?? 0.0)"
            imgProduct.backgroundColor = UIColor.random(alpha: 0.8)
      }
      
      //Click to Add to Cart
      @IBAction func clickToAddToCart(_ sender: UIButton) {
            
            let alertVC = UIAlertController.init(title: "Heady E-Commerce", message: "Item added successfully..!.", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(actionOk)
            self.present(alertVC, animated: true, completion: nil)
      }
}

//MARK:- Collection View Methods
extension ProductDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return objProductData.variants?.count ?? 0
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VariantCell", for: indexPath) as? VariantCell {
                  
                  let variant = self.objProductData.variants![indexPath.item]
                  cell.lblColor.text = variant.color ?? ""
                  if let size = variant.size {
                        cell.lblName.text = "Size: \(size)"
                  }
                  return cell
            }
            return VariantCell()
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let variant = self.objProductData.variants![indexPath.item]
            self.lblProductPrice.text = "₹\(variant.price ?? 0)"
      }
}

//MARK:- Collection View Flow Layout
extension ProductDetailsVC: UICollectionViewDelegateFlowLayout {
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let itemsPerRow: CGFloat = CGFloat(objProductData.variants?.count ?? 4)
            let hardCodedPadding: CGFloat = 10
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            return CGSize(width: itemWidth, height: 70)
      }
}
