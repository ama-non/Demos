//
//  UIBarButtonItem-Extension.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/13.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
   /*
    class func creatItem(imageName: String, highImageName: String, size: CGSize) -> UIBarButtonItem {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
    */
    
    // 便利构造函数
    convenience init(imageName: String, highImageName: String = "", size: CGSize = CGSize.zero) {
        // 创建UIButton
        let btn = UIButton()
        
        // 设置btn的图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }

        // 设置btn的尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        // 创建UIBarButtonItem
        self.init(customView: btn)
    }
}
