//
//  DialogResult.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

class DialogResult {
    var dialogView: DialogView?

    // MARK: Button Result

    var buttonIndex: Int = -2 // 点击了第几个按钮（如果为-1的话则表示点击的是空白处）

    var buttonTitle: String = "" // 点击的按钮标题

    // MARK: TextField/TextView Result

    var inputText: String = "" // 输入框文字

    // MARK: Selector Result

    var selectedIndexes: [Int] = []

    var selectedItems: [SelectorDialogItem] = []
}
