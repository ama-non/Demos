//
//  RecomandCycleView.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/6.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

private let kCycleViewID = "kCycleViewID"

class RecomandCycleView: UIView {
    // MARK:- 定义属性
    var cycleTimer: Timer?
    var cycleModels: [CycleModel]? {
        didSet {
            // 刷新collectionView
            collectionView.reloadData()
            
            // 设置pageControl个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            // 默认滚动到中间某一个位置
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 10, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            // 添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    // MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = []
        
        // 注册Cell
        collectionView.register(UINib(nibName: "CollectionViewCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleViewID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置CollectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
    }
}

// MARK:- 提供一个快速创建View的类方法
extension RecomandCycleView {
    class func recommandCycleView() -> RecomandCycleView {
        return Bundle.main.loadNibNamed("RecomandCycleView", owner: nil, options: nil)?.first as! RecomandCycleView
    }
}

// MARK:- 遵守UICollectionView的数据源协议
extension RecomandCycleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleViewID, for: indexPath) as! CollectionViewCycleCell
        
        cell.cycleModel = cycleModels![indexPath.item % cycleModels!.count]
        
        return cell
    }
}

// MARK::- 遵守UICollectionView的代理协议
extension RecomandCycleView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

// MARK:- 对定时器的操作方法
extension RecomandCycleView {
    private func addCycleTimer() {
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: .common)
    }
    
    private func removeCycleTimer() {
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc private func scrollToNext() {
        // 获取要滚动的偏移量
        let currenOffsetX = collectionView.contentOffset.x
        let offSetX = currenOffsetX + collectionView.bounds.width
        
        // 滚动该位置
        collectionView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}
