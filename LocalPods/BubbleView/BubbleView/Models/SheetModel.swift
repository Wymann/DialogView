//
//  SheetModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/15.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

struct SheetConfiguration {
    var bubbleTitle: String = "" // Sheet 标题

    var bubbleSubtitle: String = "" // Sheet 副标题

    var maxSelectNumber: Int = 1 // Sheet 最多可选的项

    var maxShowNumber: Int = 6 // Sheet 最多展示的项（超出的滑动显示）

    var buttons: [String] = ["取消"] // 按钮
    
    static let `default` = SheetConfiguration()
}

class SheetModel {
    static let empty = SheetModel(title: "",
                                  subtitle: "",
                                  selected: false)

    var title: String = "" // 选项标题

    var subtitle: String = "" // 选项副标题

    var selected: Bool = false // 选项是否被选

    init(title: String,
         subtitle: String = "",
         selected: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.selected = selected
    }
}

class SheetResult {
    var selectedIndexes: [Int] = []
    var selectedModels: [SheetModel] = []
}
