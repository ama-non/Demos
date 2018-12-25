//
//  RoomNormalViewController.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/21.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class RoomNormalViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        /*
         // 依然保持手势
         navigationController?.interactivePopGestureRecognizer?.delegate = self
         navigationController?.interactivePopGestureRecognizer?.isEnabled = true
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
