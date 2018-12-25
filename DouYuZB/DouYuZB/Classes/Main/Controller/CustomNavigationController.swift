//
//  CustomNavigationController.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/21.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 获取系统的pop手势
        guard let systemGes = interactivePopGestureRecognizer else { return }
        
        // 获取手势添加到的View中
        guard let gesView = systemGes.view else { return }
        
        // 获取target/action
        // 1.利用运行时机制查看所有的属性名称
        /*
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)
        for i in 0..<count {
            let ivar = ivars?[Int(i)]
            let name = ivar_getName(ivar!)
            print(String(cString: name!))
        }
          */
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        
        // 2.取出target
        guard let target = targetObjc.value(forKey: "target") else { return }
        
        // 3.取出action
        let action = Selector(("handleNavigationTransition:"))
        
        // 4.创建自己的Pan手势
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 隐藏push的控制器的tabbar
        viewController.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: true)
    }

}
