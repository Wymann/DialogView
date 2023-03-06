//
//  Bubble+LocalImage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/30.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

// MARK: 自动显示弹框

extension Bubble {
    /// 显示本地图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（纯文本）
    ///   - localImage: 本地图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func show(title: String,
                     subtitle: String,
                     localImage: BubbleLocalImage,
                     buttons: [String]?,
                     resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let bubbleImage = BubbleImage(localImage: localImage)
        return Bubble.show(title: title,
                           subtitle: BubbleSubtitle(subtitle: subtitle),
                           image: bubbleImage,
                           buttons: buttons,
                           resultBlock: resultBlock)
    }

    /// 显示本地图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedSubtitle: 副标题（富文本)
    ///   - localImage: 本地图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func show(title: String,
                     attributedSubtitle: NSAttributedString,
                     localImage: BubbleLocalImage,
                     buttons: [String]?,
                     resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let bubbleImage = BubbleImage(localImage: localImage)
        return Bubble.show(title: title,
                           subtitle: BubbleSubtitle(attributedSubtitle: attributedSubtitle),
                           image: bubbleImage,
                           buttons: buttons,
                           resultBlock: resultBlock)
    }
}

// MARK: 生成弹框，不自动显示

extension Bubble {
    /// 本地图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（纯文本）
    ///   - localImage: 本地图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func view(title: String,
                     subtitle: String,
                     localImage: BubbleLocalImage,
                     buttons: [String]?,
                     resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let bubbleImage = BubbleImage(localImage: localImage)
        return Bubble.view(title: title,
                           subtitle: BubbleSubtitle(subtitle: subtitle),
                           image: bubbleImage,
                           buttons: buttons,
                           resultBlock: resultBlock)
    }

    /// 本地图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedSubtitle: 副标题（富文本）
    ///   - localImage: 本地图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func view(title: String,
                     attributedSubtitle: NSAttributedString,
                     localImage: BubbleLocalImage,
                     buttons: [String]?,
                     resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let bubbleImage = BubbleImage(localImage: localImage)
        return Bubble.view(title: title,
                           subtitle: BubbleSubtitle(attributedSubtitle: attributedSubtitle),
                           image: bubbleImage,
                           buttons: buttons,
                           resultBlock: resultBlock)
    }
}
