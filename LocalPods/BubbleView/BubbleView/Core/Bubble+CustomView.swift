//
//  Bubble+CustomView.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

// MARK: 自动显示弹框

extension Bubble {
    /// 显示自定义视图弹框（固定高度，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewHeight: 自定义视图高度
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(customView: UIView,
                           customViewHeight: CGFloat,
                                  configuration: BubbleViewConfig = .default,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(customView: customView,
                          customViewHeight: customViewHeight,
                          configuration: configuration,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }

    /// 显示自定义视图弹框（固定 Size，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewSize: 自定义视图 Size
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(customView: UIView,
                           customViewSize: CGSize,
                                  configuration: BubbleViewConfig = .default,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(customView: customView,
                          customViewSize: customViewSize,
                          configuration: configuration,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension Bubble {
    /// 自定义视图弹框（固定高度，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewHeight: 自定义视图高度
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(customView: UIView,
                       customViewHeight: CGFloat,
                              configuration: BubbleViewConfig = .default,
                       resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = BubbleView()
        view.configBubbleViewByCustomHeight(customView: customView,
                                            customViewHeight: customViewHeight,
                                            configuration: configuration)
        view.bubbleResult = resultBlock
        return view
    }

    /// 自定义视图弹框（固定 Size，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewSize: 自定义视图 Size
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(customView: UIView,
                       customViewSize: CGSize,
                              configuration: BubbleViewConfig = .default,
                       resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = BubbleView()
        view.configBubbleViewByCustomSize(customView: customView,
                                          customViewSize: customViewSize,
                                          configuration: configuration)
        view.bubbleResult = resultBlock
        return view
    }
}
