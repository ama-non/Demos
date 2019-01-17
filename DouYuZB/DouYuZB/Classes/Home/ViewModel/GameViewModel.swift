//
//  GameViewModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/12.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class GameViewModel{
    lazy var games: [GameModel] = [GameModel]()
}

extension GameViewModel {
    func loadAllGameData(finishedCallback : @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail") {
            (result) in
            // 获取到数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 字典转模型
            for dict in dataArray {
                self.games.append(GameModel(dict: dict))
            }
            
            // 完成回调
            finishedCallback()
        }
    }
}

