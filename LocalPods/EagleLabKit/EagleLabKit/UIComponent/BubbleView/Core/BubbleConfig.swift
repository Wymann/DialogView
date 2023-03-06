//
//  BubbleConfig.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

/// 弹框主题字体样式配置（自定义视图除外）
struct BubbleFont {
    var normalFontName: String = "" // 普通字体
    var boldFontName: String = "" // 加粗字体

    static let `default` = BubbleFont()
}

/// 弹框主题颜色配置（自定义视图除外）
struct BubbleColor {
    var commonColor: String = "#2D3132" // 十六进制 普通颜色
    var hintColor: String = "#E64C3D" // 十六进制 提示颜色（强调按钮、输入框 hintColor）

    static let `default` = BubbleColor()
}

/// 弹框各个数值配置（自定义视图除外）
struct BubblePattern {
    var leftGap: CGFloat = 24.0 // 内容距离左边的距离
    var rightGap: CGFloat = 24.0 // 内容距离右边的距离
    var topGapWithTile: CGFloat = 24.0 // 内容距离顶部的距离（存在 Title 的情况）
    var topGapWithNoneTile: CGFloat = 36.0 // 内容距离顶部的距离（不存在 Title 的情况）
    var bottomGap: CGFloat = 24.0 // 内容距离低部按钮的距离（无按钮的话就是距离底部的距离）
    var verticalGap: CGFloat = 8.0 // 各组件之间的垂直距离(不包括底部按钮)

    var cornerRadius: CGFloat = 8.0 // 弹框圆角值
    var bubbleLeftRightMargin = 36.0 // BubbleView 距离屏幕左右的距离

    static let `default` = BubblePattern()
}

class BubbleConfig {
    static let shared = BubbleConfig()

    /// Bubble 用到的字体库（为空则选择系统字体）（自定义视图除外）
    var fonts: BubbleFont?

    /// Bubble 用到的颜色风格（自定义视图除外）
    var colors: BubbleColor = .init()

    /// Bubble 用到的各个数值配置（自定义视图除外）
    var pattern: BubblePattern = .init()

    /// Bubble 默认展示动画
    var bubbleAnimationType: BubbleShowAnimation = .showFade

    /// Bubble 默认按钮布局
    var buttonsLayoutType: BubbleButtonsLayoutType = .horizontal

    /// Bubble 默认展示时候是否弹性动画
    var bubbleBounce: Bool = false

    /// Bubble 默认展示时候是左右镜像（适配阿拉伯阅读方式，默认是 false）
    var bubbleLeftRightMirror: Bool = false
}

extension BubbleConfig {
    /// 配置全局 Bubble 参数
    /// - Parameters:
    ///   - fonts: 字体库（为空则选择系统字体）（自定义视图除外）
    ///   - colors: 颜色风格（自定义视图除外）
    ///   - pattern: 各个数值配置（自定义视图除外）
    ///   - animationType: 默认展示动画
    ///   - bounce: 默认展示时候是否弹性动画
    static func setGlobalBubble(fonts: BubbleFont? = nil,
                                colors: BubbleColor = .default,
                                pattern: BubblePattern = .default,
                                animationType: BubbleShowAnimation = .showFade,
                                bounce: Bool = false) {
        BubbleConfig.shared.fonts = fonts
        BubbleConfig.shared.colors = colors
        BubbleConfig.shared.pattern = pattern
        BubbleConfig.shared.bubbleAnimationType = animationType
        BubbleConfig.shared.bubbleBounce = bounce
    }
}

extension BubbleConfig {
    /// Bubble 获取字体
    /// - Parameter fontSize: 字体大小
    /// - Returns: 字体
    static func normalFont(ofSize fontSize: CGFloat) -> UIFont {
        let fontName = BubbleConfig.shared.fonts?.normalFontName ?? ""
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }

    /// Bubble 获取加粗字体
    /// - Parameter fontSize: 字体大小
    /// - Returns: 字体
    static func boldFont(ofSize fontSize: CGFloat) -> UIFont {
        let fontName = BubbleConfig.shared.fonts?.boldFontName ?? ""
        return UIFont(name: fontName, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
    }

    /// 普通颜色
    /// - Returns: 十六进制字符串
    static func commonColor() -> String {
        return BubbleConfig.shared.colors.commonColor
    }

    /// 提示颜色（强调按钮、输入框 hintColor）
    /// - Returns: 十六进制字符串
    static func hintColor() -> String {
        return BubbleConfig.shared.colors.hintColor
    }

    /// 各个数值配置（自定义视图除外）
    /// - Returns: BubblePattern
    static func pattern() -> BubblePattern {
        return BubbleConfig.shared.pattern
    }
}
