//
//  FunnyViewController.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/21.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

private let kTopMargin: CGFloat = 8

class FunnyViewController: BaseAnchorViewController {
    // MARK:- 懒加载ViewModel对象
    fileprivate lazy var funnyVM: FunnyViewModel = FunnyViewModel()
}

extension FunnyViewController {
    override func setupUI() {
        super.setupUI()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
        collectionView.contentInset = UIEdgeInsets(top: kTopMargin, left: 0, bottom: 0, right: 0)
    }
}

extension FunnyViewController {
    override func loadData() {
        // 给父类的ViewModel赋值
        baseVM = funnyVM
        
        // 请求数据
        funnyVM.loadFunnyData {
            self.collectionView.reloadData()
            
            // 数据请求完成
            self.loadDataFinished()
        }
    }
}
