//
//  ShareModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/10/8.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

struct ShareConfiguration {
    var bubbleTitle: String = "" // Share 标题

    var bubbleSubtitle: String = "" // Share 副标题

    var rowCount: Int = 4 // 列数

    var buttons: [String] = ["取消"] // 按钮

    static let `default` = ShareConfiguration()
}

class ShareModel {
    static let empty = ShareModel(title: "")

    var title: String = "" // 标题

    var icon: UIImage? // 图标

    init(title: String = "", icon: UIImage? = nil) {
        self.title = title
        self.icon = icon
    }
}
