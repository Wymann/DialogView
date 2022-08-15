//
//  BubbleViewConfig.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

/// Bubble 显示时候的动画
enum BubbleShowAnimation {
    case showFromTop
    case showFromLeft
    case showFromBottom
    case showFromRight
    case showFade
    case showNone
}

/// Bubble 最后显示的位置
enum BubbleStayPosition {
    case stayMiddle
    case stayBottom
    case stayTop
}

/// BubbleView 一些配置参数
struct BubbleViewConfig {
    var animation: BubbleShowAnimation = BubbleConfig.shared.bubbleAnimationType // 出现时候的动画
    var position: BubbleStayPosition = .stayMiddle // 最后停留的位置
    var sideTap: Bool = true // 点击周边空白处是否关闭
    var bounce: Bool = BubbleConfig.shared.bubbleBounce // 是否弹性动画弹出
}
