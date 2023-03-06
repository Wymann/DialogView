//
//  TextFieldBubbleModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/21.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class TextFieldBubbleModel: BasicBubbleModel {
    var textAlignment: NSTextAlignment = .left // 文本位置

    var textContent: String = "" // 文本内容

    var placeHolderContent: String = "" // 占位文本内容

    var fontSize: CGFloat = 14.0 // 文本大小

    var textColor: String = "#000000" // 文本颜色

    var textFieldEdgeInsets: UIEdgeInsets = .zero // 文本输入框四周边距

    var keyboardType: UIKeyboardType = .default // 文本输入框四周边距

    var tintColor: String = "#000000" // 会影响光标等颜色

    var secureTextEntry: Bool = false // 是否保密输入

    var clearButtonMode: UITextField.ViewMode = .never // 右边清空按钮显示模式
}
