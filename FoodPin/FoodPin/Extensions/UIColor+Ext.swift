//
//  UIColor+Ext.swift
//  FoodPin
//
//  Created by 徐亦农 on 2019/1/21.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let bulueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: bulueValue, alpha: 1.0)
    }
}
