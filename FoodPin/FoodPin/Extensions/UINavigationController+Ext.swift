//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by 徐亦农 on 2019/1/21.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
