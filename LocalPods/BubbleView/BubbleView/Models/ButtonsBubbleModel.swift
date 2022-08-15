//
//  ButtonsBubbleModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

/// 按钮布局类型
enum BubbleButtonsLayoutType {
    case horizontal
    case vertical
}

class ButtonsBubbleModel: BasicBubbleModel {
    var buttonTitles: [String] = [] // 按钮标题

    var textColors: [String] = [] // 文本颜色数组

    var fontSize: CGFloat = 14.0 // 文本大小

    var bold: Bool = false // 文本是否加粗

    var layoutType: BubbleButtonsLayoutType = .horizontal // 按钮布局样式
}
