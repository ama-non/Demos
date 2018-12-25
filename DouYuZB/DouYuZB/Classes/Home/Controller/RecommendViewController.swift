//
//  RecommendViewController.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/22.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

private let kCycleViewH = kScreenW * 3 / 8
private let kGameViewH: CGFloat = 90

class RecommendViewController: BaseAnchorViewController {
    // MARK:- 懒加载属性
    private lazy var recommendVM: RecommendViewModel = RecommendViewModel()
    private lazy var cycleView: RecomandCycleView = {
        let cycleView = RecomandCycleView.recommandCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    private lazy var gameView: RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
}

// MARK:- 设置UI界面
extension RecommendViewController {
    override func setupUI() {
        super.setupUI()
        
        // 将UICollectionView添加到控制器的view中
        view.addSubview(collectionView)
        
        // 将CycleView添加到UICollectionView中
        collectionView.addSubview(cycleView)
        
        // 将gameView添加到UICollectionView中
        collectionView.addSubview(gameView)
        
        // 设置CollectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
}

// MARK:- 请求数据
extension RecommendViewController {
    override func loadData() {
        // 给父类的viewModel进行赋值
        baseVM = recommendVM
        
        // 请求推荐数据
        recommendVM.requestData {
            // 展示推荐数据
            self.collectionView.reloadData()
            
            var groups = self.recommendVM.anchorGroups
            
            // 移除前两组数据
            groups.removeFirst()
            groups.removeFirst()
            
            // 添加更多组
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            
            // 将数据传递给GameView
            self.gameView.groups = groups
            
            // 数据请求完成
            self.loadDataFinished()
        }
        
        // 请求轮播数据
        recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
    }
}

// MARK:- 遵守UICollectionView的数据源协议
extension RecommendViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 取出Cell
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBeautyCellID, for: indexPath) as! CollectionBeautyCell
            
            cell.anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            
            return cell
        } else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemW, height: kBeautyItemH)
        }
        
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
    
}
