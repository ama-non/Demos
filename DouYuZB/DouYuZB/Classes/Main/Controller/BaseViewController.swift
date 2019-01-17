//
//  BaseViewController.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/21.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK:- 定义属性
    var contenView: UIView?
    
    // MARK:- 懒加载属性
    fileprivate lazy var animImageView: UIImageView = {[unowned self] in
        let imageView = UIImageView(image: UIImage(named: "img_loading_1"))
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named: "img_loading_1")!, UIImage(named: "img_loading_2")!]
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = LONG_MAX
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        
        return imageView
    }()

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

extension BaseViewController {
    @objc func setupUI() {
        // 隐藏内容的View
        contenView?.isHidden = true
        
        // 添加执行该动画的UIImageView
        view.addSubview(animImageView)
        
        // 执行动画
        animImageView.startAnimating()
        
        // 设置View的背景颜色
        view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    
    func loadDataFinished() {
        // 停止动画
        animImageView.stopAnimating()
        
        
        // 隐藏animImageView
        animImageView.isHidden = true
        
        // 显示内容View
        contenView?.isHidden = false
    }
}
