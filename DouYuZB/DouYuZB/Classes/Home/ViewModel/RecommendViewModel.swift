//
//  RecommendViewModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/28.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class RecommendViewModel {
    // 懒加载属性
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
    lazy var cycleModels: [CycleModel] = [CycleModel]()
    private lazy var bigDataGroup: AnchorGroup = AnchorGroup()
    private lazy var beautyGroup: AnchorGroup = AnchorGroup()
}

// MARK:- 发送网络请求
extension RecommendViewModel {
    // 请求推荐数据
    func requestData(finishedCallBack: @escaping () -> ()) {
        let parameters = ["limit" : "4", "offset" : "0", "time" : Date.getCurrentTime()]
        
        // 创建group
        let dGroup = DispatchGroup()
        
        // 请求第一部分推荐数据
        dGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getBigDataRoom", parameters: ["time" : Date.getCurrentTime()]) { (result) in
            // 将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 根据data的Key获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 遍历字典，并且转为模型对象
            
            // 设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            // 获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            
            dGroup.leave()
        }
        
        // 请求第二部分颜值数据
        dGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            // 将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 根据data的Key获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 遍历字典，并且转为模型对象
            
            // 设置组的属性
            self.beautyGroup.tag_name = "颜值"
            self.beautyGroup.icon_name = "home_header_phone"
            
            // 获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.beautyGroup.anchors.append(anchor)
            }
            dGroup.leave()
        }
        
        dGroup.enter()
        // 请求2-12部分游戏数据
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            // 将result转成字典类型
            guard let resultDict = result as? [String : Any] else { return }
            
            // 根据data的Key获取数组
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            
            // 遍历数组，获取字典，并且将字典转成模型对象
            for dict in dataArray {
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
            
            dGroup.leave()
        }
        
        // 所有的数据都请求到，然后进行排序
        dGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.beautyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishedCallBack()
        }
    }
    
    // 请求无限轮播的数据
    func requestCycleData(finishedCallBack: @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"]) { (result) in
            // 获取整体数据
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }
            
            finishedCallBack()
        }
    }
}
