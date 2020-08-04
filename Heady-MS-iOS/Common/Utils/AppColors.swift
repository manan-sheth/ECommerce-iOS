//
//  AppColors.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 03/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import UIKit

extension CGFloat {
      
      /**
       Generate a random value
       
       - Returns: Random float value
       */
      static func random() -> CGFloat {
            return CGFloat(arc4random()) / CGFloat(UInt32.max)
      }
}

extension UIColor {
      
      /**
       Generates a random color.
       
       - Parameter alpha: Opacity value. (User can skip parameter too)
       
       - Returns: Random color
       */
      static func random(alpha: CGFloat? = 1.0) -> UIColor {
            return UIColor(
                  red:   .random(),
                  green: .random(),
                  blue:  .random(),
                  alpha: alpha!
            )
      }
}
