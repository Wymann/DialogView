//
//  Bubble+SpecialColors.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

struct BubbleSpecialColor {
    var titleColor: String = "" // 标题颜色
    var subtitleColor: String = "" // 副标题颜色
    var buttonColors: [String] = [] // 按钮颜色
}

struct BubbleSubtitle {
    var subtitle: String = "" // 副标题
    var attributedSubtitle: NSAttributedString? // 富文本形式的副标题
}

// MARK: 自动显示弹框

extension Bubble {
    /// 显示普通标题和副标题（非富文本）（颜色自定义）
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（非富文本）
    ///   - buttons: 按钮
    ///   - specialColor: 文字颜色配置
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(title: String,
                           subtitle: String,
                           buttons: [String]?,
                           specialColor: BubbleSpecialColor,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          subtitle: BubbleSubtitle(subtitle: subtitle),
                          buttons: buttons,
                          specialColor: specialColor,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }

    /// 显示普通标题和副标题（富文本）（颜色自定义）
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedSubtitle: 副标题（富文本）
    ///   - buttons: 按钮
    ///   - specialColor: 文字颜色配置
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(title: String,
                           attributedSubtitle: NSAttributedString,
                           buttons: [String]?,
                           specialColor: BubbleSpecialColor,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          subtitle: BubbleSubtitle(attributedSubtitle: attributedSubtitle),
                          buttons: buttons,
                          specialColor: specialColor,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension Bubble {
    /// 自定义各种文字颜色的弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮
    ///   - specialColor: 文字颜色配置
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(title: String,
                       subtitle: BubbleSubtitle,
                       buttons: [String]?,
                       specialColor: BubbleSpecialColor,
                       resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        var array: [BasicBubbleModel] = []

        if !title.isEmpty {
            let textModel = BubbleModelEditor.createTextBubbleModel(title: title,
                                                                    titleColor: specialColor.titleColor)
            array.append(textModel)
        }

        if !subtitle.subtitle.isEmpty {
            let textModel = BubbleModelEditor.createTextBubbleModel(subtitle: subtitle.subtitle,
                                                                    subtitleColor: specialColor.subtitleColor)
            array.append(textModel)
        } else if let attributedSubText = subtitle.attributedSubtitle, !attributedSubText.string.isEmpty {
            let textModel = BubbleModelEditor.createTextBubbleModel(attributedSubtitle: attributedSubText, subtitleColor: "")
            array.append(textModel)
        }

        BubbleModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

        if let buttonsArray = buttons, !buttonsArray.isEmpty {
            let buttonsModel = BubbleModelEditor.createButtonsBubbleModel(buttons: buttonsArray,
                                                                          buttonColors: specialColor.buttonColors)
            array.append(buttonsModel)
        }

        let view = BubbleView()
        view.configBubbleView(bubbleModels: array)
        view.bubbleResult = resultBlock
        return view
    }
}
