//
//  Bubble+NetImage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/30.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

// MARK: 自动显示弹框

extension Bubble {
    /// 显示网络图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（纯文本）
    ///   - netImage: 网络图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func show(title: String,
                     subtitle: String,
                     netImage: BubbleNetImage,
                     buttons: [String]?,
                     resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let bubbleImage = BubbleImage(netImage: netImage)
        return Bubble.show(title: title,
                           subtitle: BubbleSubtitle(subtitle: subtitle),
                           image: bubbleImage,
                           buttons: buttons,
                           resultBlock: resultBlock)
    }
}

// MARK: 生成弹框，不自动显示

extension Bubble {
    /// 网络图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（纯文本）
    ///   - netImage: 网络图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func view(title: String,
                     subtitle: String,
                     netImage: BubbleNetImage,
                     buttons: [String]?,
                     resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let bubbleImage = BubbleImage(netImage: netImage)
        return Bubble.view(title: title,
                           subtitle: BubbleSubtitle(subtitle: subtitle),
                           image: bubbleImage,
                           buttons: buttons,
                           resultBlock: resultBlock)
    }
}
