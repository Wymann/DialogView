//
//  TextBubbleModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/21.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class TextBubbleModel: BasicBubbleModel {
    var textAlignment: NSTextAlignment = .left // 文本位置

    var textContent: String = "" // 文本内容

    var attributedTextContent: NSAttributedString = .init() // 文本内容（富文本）

    var fontSize: CGFloat = 16.0 // 文本大小

    var lineSpace: CGFloat = 3.0 // 行间距

    var textColor: String = "#000000" // 文本颜色

    var richText: [[String: Any]] = [] // 富文本数组

    var textEdgeInsets: UIEdgeInsets = .zero // 文本四周边距

    var maxLines: Int = 0 // 文本最大行数（设置为大于0后生效）

    var maxHeight: CGFloat = 0.0 // 文本最大高度（设置为大于0后生效）

    var scrollable: Bool = false // 文本超过最大高度后可滚动（只在maxHeight大于0的情况下scrollable判断生效）

    var bold: Bool = false // 是否加粗
}
