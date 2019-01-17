//
//  BaseAnchorViewController.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/20.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kHeaderViewH: CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"

let kBeautyCellID = "kBeautyCellID"
let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4
let kBeautyItemH = kNormalItemW * 4 / 3

class BaseAnchorViewController: BaseViewController {
    
    // MARK:- 定义属性
    var baseVM: BaseViewModel!
    
    // MARK:- 懒加载属性
    lazy var collectionView: UICollectionView = {[unowned self] in
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionBeautyCell", bundle: nil), forCellWithReuseIdentifier: kBeautyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
        }()

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        loadData()
    }

}

// MARK:- 设置UI界面
extension BaseAnchorViewController {
    override func setupUI() {
        // 给父类中内容View的引用进行赋值
        contenView = collectionView
        
        // 添加collectionView
        view.addSubview(collectionView)
        
        // 调用super.setupUI
        super.setupUI()
    }
}

// MARK:- 请求数据
extension BaseAnchorViewController {
    @objc func loadData() {
    }
}

//MARK:- 遵守UICollectionView的数据源
extension BaseAnchorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        
        // 给cell设置数据
        cell.anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 取出headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        // 给headerView设置数据
        headerView.group = baseVM.anchorGroups[indexPath.section]
        
        return headerView
    }
}

//MARK:- 遵守UICollectionView的代理协议
extension BaseAnchorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 取出对应的主播信息
        let anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        // 判断是普通房间&秀场房间
        anchor.isVertical == 0 ? pushNormalRoomVc() : presentShowRoomVc()
    }
    
    private func presentShowRoomVc() {
        // 创建ShowRoomVc
        let showRoomVc = RoomShowViewController()
        
        // 以Modal方式弹出
        present(showRoomVc, animated: true, completion: nil)
    }
    
    private func pushNormalRoomVc() {
        // 创建NormalRoomVc
        let normalRoomVc = RoomNormalViewController()
        
        // 以Push方式弹出
        navigationController?.pushViewController(normalRoomVc, animated: true)
    }
}
