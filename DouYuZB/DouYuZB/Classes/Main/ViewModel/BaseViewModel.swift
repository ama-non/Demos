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
    func loadAnchorData(URLString: String, parameters: [String: Any]? = nil,
                        finishedCallBack: @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: URLString, parameters: parameters) { (result) in
            // 对界面进行处理
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            //遍历数组
            for dict in dataArray {
                self.anchorGroups.append(AnchorGroup(dict: dict))
            }
            
            // 完成回调
            finishedCallBack()
        }
    }
}
