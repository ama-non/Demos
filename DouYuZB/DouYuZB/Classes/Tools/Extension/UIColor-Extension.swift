//
//  UIColor-Extension.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/15.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
