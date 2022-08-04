//
//  DialogConfig.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

/// 弹框主题字体样式配置（自定义视图除外）
struct DialogFont {
    var normalFontName: String = "" // 普通字体
    var boldFontName: String = "" // 加粗字体
}

/// 弹框主题颜色配置（自定义视图除外）
struct DialogColor {
    var commonColor: String = "#2D3132" // 十六进制 普通颜色
    var hintColor: String = "#E64C3D" // 十六进制 提示颜色（强调按钮、输入框 hintColor）
}

/// 弹框各个数值配置（自定义视图除外）
struct DialogPattern {
    var leftGap: CGFloat = 24.0 // 内容距离左边的距离
    var rightGap: CGFloat = 24.0 // 内容距离右边的距离
    var topGapWithTile: CGFloat = 24.0 // 内容距离顶部的距离（存在 Title 的情况）
    var topGapWithNoneTile: CGFloat = 36.0 // 内容距离顶部的距离（不存在 Title 的情况）
    var bottomGap: CGFloat = 24.0 // 内容距离低部按钮的距离（无按钮的话就是距离底部的距离）
    var verticalGap: CGFloat = 8.0 // 各组件之间的垂直距离(不包括底部按钮)

    var cornerRadius: CGFloat = 8.0 // 弹框圆角值
    var dialogLeftRightMargin = 36.0 // DialogView 距离屏幕左右的距离
}

class DialogConfig {
    static let shared = DialogConfig()

    /// Dialog 用到的字体库（为空则选择系统字体）（自定义视图除外）
    var fonts: DialogFont?

    /// Dialog 用到的颜色风格（自定义视图除外）
    var colors: DialogColor = .init()

    /// Dialog 用到的各个数值配置（自定义视图除外）
    var pattern: DialogPattern = .init()

    /// Dialog 默认展示动画
    var dialogAnimationType: DialogShowAnimation = .showFade

    /// Dialog 默认按钮布局
    var buttonsLayoutType: DialogButtonsLayoutType = .horizontal

    /// Dialog 默认展示时候是否弹性动画
    var dialogBounce: Bool = false
}

extension DialogConfig {
    /// 配置全局 Dialog 参数
    /// - Parameters:
    ///   - fonts: 字体库（为空则选择系统字体）（自定义视图除外）
    ///   - colors: 颜色风格（自定义视图除外）
    ///   - pattern: 各个数值配置（自定义视图除外）
    ///   - animationType: 默认展示动画
    ///   - bounce: 默认展示时候是否弹性动画
    static func setGlobalDialog(fonts: DialogFont? = nil,
                                colors: DialogColor = DialogColor(),
                                pattern: DialogPattern = DialogPattern(),
                                animationType: DialogShowAnimation = .showFade,
                                bounce: Bool = false) {
        DialogConfig.shared.fonts = fonts
        DialogConfig.shared.colors = colors
        DialogConfig.shared.pattern = pattern
        DialogConfig.shared.dialogAnimationType = animationType
        DialogConfig.shared.dialogBounce = bounce
    }
}

extension DialogConfig {
    /// Dialog 获取字体
    /// - Parameter fontSize: 字体大小
    /// - Returns: 字体
    static func normalFont(ofSize fontSize: CGFloat) -> UIFont {
        let fontName = DialogConfig.shared.fonts?.normalFontName ?? ""
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }

    /// Dialog 获取加粗字体
    /// - Parameter fontSize: 字体大小
    /// - Returns: 字体
    static func boldFont(ofSize fontSize: CGFloat) -> UIFont {
        let fontName = DialogConfig.shared.fonts?.boldFontName ?? ""
        return UIFont(name: fontName, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
    }

    /// 普通颜色
    /// - Returns: 十六进制字符串
    static func commonColor() -> String {
        return DialogConfig.shared.colors.commonColor
    }

    /// 提示颜色（强调按钮、输入框 hintColor）
    /// - Returns: 十六进制字符串
    static func hintColor() -> String {
        return DialogConfig.shared.colors.hintColor
    }

    /// 各个数值配置（自定义视图除外）
    /// - Returns: DialogPattern
    static func pattern() -> DialogPattern {
        return DialogConfig.shared.pattern
    }
}
