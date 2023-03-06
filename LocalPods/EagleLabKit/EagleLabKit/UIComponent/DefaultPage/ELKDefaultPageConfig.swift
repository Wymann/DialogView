//
//  ELKDefaultPageConfig.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/13.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

/// 缺省页主题字体样式配置（自定义视图除外）
struct ELKDefaultPageFont {
    var normalFontName: String = "" // 普通字体
    var boldFontName: String = "" // 加粗字体

    var titleFontSize: CGFloat = 18.0 // 标题字体大小
    var subtitleFontSize: CGFloat = 16.0 // 副标题字体大小
    var buttonFontSize: CGFloat = 18.0 // 按钮字体大小
}

/// 缺省页主题颜色配置（自定义视图除外）
struct ELKDefaultPageColor {
    var titleColor: String = "#212126" // 标题颜色
    var subtitleColor: String = "#21212666" // 副标题颜色
    var buttonTextColor: String = "#FFFFFF" // 按钮文字颜色
    var buttonBorderColor: String = "#212126" // 按钮边框颜色
    var buttonBackgroundColor: String = "#212126" // 按钮背景颜色
}

/// 缺省页各个数值配置（自定义视图除外）
struct ELKDefaultPagePattern {
    var imageSize: CGSize = .init(width: 200.0, height: 200.0) // 缺省图片尺寸
    var imageTitleGap: CGFloat = 24.0 // 缺省图与标题（或副标题）的间距
    var titleSubtitleGap: CGFloat = 8.0 // 标题与副标题（如果存在副标题的话）的间距
    var titleButtonGap: CGFloat = 24.0 // 标题（如果存在副标题的话就是副标题）与底部按钮的间距
    var buttonLeftRightMargin: CGFloat = 24.0 // 按钮文字距离左右的间距
    var buttonHeight: CGFloat = 40.0 // 按钮高度
    var contentLeftRightMargin: CGFloat = 24.0 // 内容距离左右的间距
}

/// 缺省页内容位置
struct ELKDefaultPagePosition {
    var style: ELKDefaultPageStyle = .top // 缺省页内容位置风格（默认偏上）
    var topGap: CGFloat = 120.0 // 缺省页内容偏顶部时候距离顶部间距（默认）
    var bottomGap: CGFloat = 120.0 // 缺省页内容偏底部时候距离顶部间距（默认）
}

class ELKDefaultPageConfig {
    static let defaultPageTag: Int = 9999
    static let shared = ELKDefaultPageConfig()

    /// ELKDefaultPage 用的字体库（为空则选择系统字体）以及字体大小，（自定义视图除外）
    var fonts: ELKDefaultPageFont = .init()

    /// ELKDefaultPage 用到的颜色风格（自定义视图除外）
    var colors: ELKDefaultPageColor = .init()

    /// ELKDefaultPage 用到的各个数值配置（自定义视图除外）
    var pattern: ELKDefaultPagePattern = .init()

    /// ELKDefaultPage 内容位置数值配置
    var position: ELKDefaultPagePosition = .init()
}

extension ELKDefaultPageConfig {
    /// 配置全局 ELKDefaultPage 参数
    /// - Parameters:
    ///   - fonts: 字体库（为空则选择系统字体）以及字体大小，（自定义视图除外）
    ///   - colors: 用到的颜色风格（自定义视图除外）
    ///   - pattern: 用到的各个数值配置（自定义视图除外）
    static func setGlobalDefaultPage(fonts: ELKDefaultPageFont = .init(),
                                     colors: ELKDefaultPageColor = .init(),
                                     pattern: ELKDefaultPagePattern = .init(),
                                     position: ELKDefaultPagePosition = .init()) {
        ELKDefaultPageConfig.shared.fonts = fonts
        ELKDefaultPageConfig.shared.colors = colors
        ELKDefaultPageConfig.shared.pattern = pattern
        ELKDefaultPageConfig.shared.position = position
    }
}

extension ELKDefaultPageConfig {
    /// 获取标题字体
    /// - Returns: 字体
    static func titleFont() -> UIFont {
        let fontName = ELKDefaultPageConfig.shared.fonts.normalFontName
        let fontSize = ELKDefaultPageConfig.shared.fonts.titleFontSize
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }

    /// 获取副标题字体
    /// - Returns: 字体
    static func subtitleFont() -> UIFont {
        let fontName = ELKDefaultPageConfig.shared.fonts.normalFontName
        let fontSize = ELKDefaultPageConfig.shared.fonts.subtitleFontSize
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }

    /// 获取按钮字体
    /// - Returns: 字体
    static func buttonTextFont() -> UIFont {
        let fontName = ELKDefaultPageConfig.shared.fonts.normalFontName
        let fontSize = ELKDefaultPageConfig.shared.fonts.buttonFontSize
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
