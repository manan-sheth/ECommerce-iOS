//
//  BannerRow.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

class BannerRow: UITableViewCell {
      
      @IBOutlet weak var collectionView: UICollectionView!
      
      //MARK:- Class Methods
      override func awakeFromNib() {
            _ =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
      }
      
      //Automatically Scroll to next item
      /**
       Automatically Scrolls to next item for banner listing
       
       - Parameter timer: Time Interval (Helps to scroll object at certain time)
       */
      @objc func scrollAutomatically(_ timer: Timer) {
            
            for cell in collectionView.visibleCells {
                  
                  if let indexPath = collectionView.indexPath(for: cell) {
                        if indexPath.item < 2 {
                              let newIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                              collectionView.scrollToItem(at: newIndexPath, at: .right, animated: true)
                        }
                        else {
                              let newIndexPath = IndexPath(item: 0, section: indexPath.section)
                              collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
                        }
                  }
            }
      }
}

//MARK:- Collection View Methods
extension BannerRow: UICollectionViewDataSource {
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.lblBanner.text = indexPath.row == 0 ? "Independence Day Sale" : indexPath.row == 1 ? "Upto 60% Off" : "Festival Sale"
            cell.imgBanner.backgroundColor = UIColor.random(alpha: 0.8)
            return cell
      }
}

//MARK:- Collection View Flow Layout
extension BannerRow: UICollectionViewDelegateFlowLayout {
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
      }
}

//MARK:- Banner Cell
class BannerCell: UICollectionViewCell {
      
      @IBOutlet weak var imgBanner: UIImageView!
      @IBOutlet weak var lblBanner: UILabel!
}
