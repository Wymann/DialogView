//
//  DialogViewConfig.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

/// Dialog 显示时候的动画
enum DialogShowAnimation {
    case showFromTop
    case showFromLeft
    case showFromBottom
    case showFromRight
    case showFade
    case showNone
}

/// Dialog 最后显示的位置
enum DialogStayPosition {
    case stayMiddle
    case stayBottom
    case stayTop
}

/// DialogView 一些配置参数
struct DialogViewConfig {
    var animation: DialogShowAnimation = DialogConfig.shared.dialogAnimationType // 出现时候的动画
    var position: DialogStayPosition = .stayMiddle // 最后停留的位置
    var sideTap: Bool = true // 点击周边空白处是否关闭
    var bounce: Bool = DialogConfig.shared.dialogBounce // 是否弹性动画弹出
}
