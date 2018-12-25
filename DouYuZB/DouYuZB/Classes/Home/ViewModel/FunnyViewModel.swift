//
//  FunnyViewModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/21.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class FunnyViewModel: BaseViewModel {

}

extension FunnyViewModel {
    func loadFunnyData(finishedCallBack: @escaping () -> ()) {
        loadAnchorData(isGroupData: false, URLString: "http://capi.douyucdn.cn/api/v1/getColumnRoom/3", parameters: ["limit" : 30, "offset" : 0], finishedCallBack: finishedCallBack)
    }
}
