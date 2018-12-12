//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/13.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

protocol PageTitlteViewDelegate: class {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}

private let kScrollLineH: CGFloat = 2
private let kNormalColor: (CGFloat, CGFloat ,CGFloat) = (85, 85, 85)
private let kSelectedColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    
    // MARK:- 定义属性
    private var currentIndex: Int = 0
    private var titles: [String]
    weak var delegate: PageTitlteViewDelegate? //协议最好使用weak
    
    // MARK:- 懒加载属性
    private lazy var titleLabels: [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
    }()
    private lazy var scrollLine: UIView = {
       let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        
        return scrollLine
    }()

    // MARK:- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 设置UI界面
extension PageTitleView {
    private func setupUI() {
        // 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        NSLog("scrollView.frame: %@", NSCoder.string(for: scrollView.frame))
        // 添加Title对应的Label
        setupTitleLabels()
        
        // 设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels() {
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            // 创建UILbabel
            let label = UILabel()
            
            // 设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            // 设置label的frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        
            //将label添加到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        // 添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 添加ScrollLine
        guard let firstLabel = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

// MARK:- 监听label的点击
extension PageTitleView {
    @objc private func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 获取当前label
        guard let currentLabel = tapGes.view as? UILabel else {
            return
        }
        
        // 如果重复点击同一个Title，那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 获取当前的label
        currentIndex = currentLabel.tag
        
        // 滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

// MARK:- 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        // 取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 处理滑块逻辑
        let moveTotlalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = progress * moveTotlalX
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 颜色的渐变（复杂）
        // 1.取出变化的范围
        let colorDelta = (kSelectedColor.0 - kNormalColor.0, kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kSelectedColor.2)
        
        // 2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progress ,
                                    g: kSelectedColor.1 - colorDelta.1 * progress,
                                    b: kSelectedColor.2 - colorDelta.2 * progress)
        
        // 3.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress,
                                        g: kNormalColor.1 + colorDelta.1 * progress,
                                        b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}
