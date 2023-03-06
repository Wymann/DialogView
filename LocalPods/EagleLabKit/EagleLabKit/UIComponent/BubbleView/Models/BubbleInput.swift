//
//  BubbleSingleLineInput.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/30.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

struct BubbleTextFieldInput {
    var inputText: String = "" // 输入框初始文字

    var placeHolder: String = "" // 输入框占位文字

    var keyboardType: UIKeyboardType = .default // 键盘类型

    var secureTextEntry: Bool = false // 是否保密输入

    var clearButtonMode: UITextField.ViewMode = .never // 右边清空按钮显示模式
}

struct BubbleTextViewInput {
    var inputText: String = "" // 输入框初始文字

    var placeHolder: String = "" // 输入框占位文字

    var keyboardType: UIKeyboardType = .default // 键盘类型

    var maxTextLength: Int = 100 // 允许输入的最大数字
}
