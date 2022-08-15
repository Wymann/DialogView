//
//  BubbleViewModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/25.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class BubbleViewModel {
    var backStartColor: UIColor = .init(hex: 0x000000, alpha: 0)
    var backFinalColor: UIColor = .init(hex: 0x000000, alpha: 0.5)

    var existPriority: Bool = false // 是否存在优先级
    var bubbleModels: [Any]? // 数据模型
    var configuration: BubbleViewConfig = .init()
    var openedKeyboard: Bool = false // 键盘是否开启
    var startRect: CGRect = .zero // contentView 初始位置
    var finalRect: CGRect = .zero // contentView 最后位置
    var contentViewWidth: CGFloat = 0 // contentView 宽
    var contentViewHeight: CGFloat = 0 // contentView 高
    var buttonModel: ButtonsBubbleModel? // 按钮
    var textViewMaxLength: Int = 0 // TextView 最大数字限制(默认0，表示不做限制)
    var customViewWidth: CGFloat = 0 // contentView 宽
    var customViewHeight: CGFloat = 0 // contentView 高

    var boundViewController: UIViewController? // 绑定的控制器（只有这个控制器显示的时候才弹框）
    var textField: UITextField? // 单行输入框
    var textView: UITextView? // 多行输入框
    var selectorElement: SelectorBubbleElement? // 选择器组件
    var errorLabel: UILabel? // 输入框错误提醒
    var maxLengthLabel: UILabel? // 输入框字数实时
    var buttonsElement: ButtonsBubbleElement? // 按钮面板
    var customView: UIView? // 自定义视图

    func calculateFinalRect() {
        var finalRectY: CGFloat = 0
        switch configuration.position {
        case .stayMiddle: finalRectY = (BubbleView.bubbleScreenHeight - contentViewHeight) / 2
        case .stayBottom: finalRectY = BubbleView.bubbleScreenHeight - contentViewHeight
        case .stayTop: finalRectY = 0
        }
        finalRectY = floor(finalRectY)

        let finalRectX: CGFloat = floor((BubbleView.bubbleScreenWidth - contentViewWidth) / 2)
        finalRect = CGRect(x: finalRectX,
                           y: finalRectY,
                           width: contentViewWidth,
                           height: contentViewHeight)
    }

    func calculateStartRect() {
        switch configuration.animation {
        case .showNone:
            startRect = finalRect
        case .showFromTop:
            startRect = CGRect(x: finalRect.minX,
                               y: -finalRect.height,
                               width: contentViewWidth,
                               height: contentViewHeight)
        case .showFromLeft:
            startRect = CGRect(x: -finalRect.width,
                               y: finalRect.minY,
                               width: contentViewWidth,
                               height: contentViewHeight)
        case .showFromBottom:
            startRect = CGRect(x: finalRect.minX,
                               y: BubbleView.bubbleScreenHeight,
                               width: contentViewWidth,
                               height: contentViewHeight)
        case .showFromRight:
            startRect = CGRect(x: BubbleView.bubbleScreenWidth + finalRect.width,
                               y: finalRect.minY,
                               width: contentViewWidth,
                               height: contentViewHeight)
        case .showFade:
            startRect = finalRect
        }
    }
}
