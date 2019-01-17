//
//  AmuseViewModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/20.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class AmuseViewModel: BaseViewModel {
    
}

extension AmuseViewModel {
    func loadAmuseData(finishedCallBack: @escaping () -> ()) {
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishedCallBack: finishedCallBack)
    }
}
