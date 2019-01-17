//
//  MainViewController.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/13.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc("Home")
        addChildVc("Live")
        addChildVc("Follow")
        addChildVc("Profile")
    }
    
    private func addChildVc(_ storyName: String) {
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        addChild(childVc)
    }

}
