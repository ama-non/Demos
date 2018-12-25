//
//  BaseViewModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/20.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class BaseViewModel {
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
}

extension BaseViewModel {
    func loadAnchorData(isGroupData: Bool, URLString: String, parameters: [String: Any]? = nil,
                        finishedCallBack: @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: URLString, parameters: parameters) { (result) in
            // 对界面进行处理
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 判断是否是分组数据
            if isGroupData {
                //遍历数组
                for dict in dataArray {
                    self.anchorGroups.append(AnchorGroup(dict: dict))
                }
            } else {
                // 创建组
                let group = AnchorGroup()
                
                // 遍历dataArray中的所有字典
                for dict in dataArray {
                    group.anchors.append(AnchorModel(dict: dict))
                }
                
                // 将group添加到anchorGroups
                self.anchorGroups.append(group)
            }
            
            // 完成回调
            finishedCallBack()
        }
    }
}
