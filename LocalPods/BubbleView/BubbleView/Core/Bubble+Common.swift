//
//  Bubble+Common.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/23.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

// MARK: 自动显示弹框

extension Bubble {
    /// 显示普通标题和副标题
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(title: String,
                                  subtitle: String,
                                  buttons: [String]?,
                                  resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title:
            title,
            subtitle:
            subtitle,
            buttons: buttons,
            resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }

    ///  显示普通标题和副标题（可定义按钮布局）
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮标题
    ///   - buttonsLayoutType: 按钮布局样式
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(title: String,
                                  subtitle: String,
                                  buttons: [String]?,
                                  buttonsLayoutType: BubbleButtonsLayoutType,
                                  resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          subtitle: subtitle,
                          buttons: buttons,
                          buttonsLayoutType: buttonsLayoutType,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }

    /// 显示普通标题和副标题（副标题是富文本）
    /// - Parameters:
    ///   - title: 主标题
    ///   - attributedSubtitle: 富文本副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(title: String,
                           attributedSubtitle: NSAttributedString?,
                           buttons: [String]?,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          attributedSubtitle: attributedSubtitle,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension Bubble {
    /// 普通标题和副标题
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(title: String,
                       subtitle: String,
                       buttons: [String]?,
                       resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          subtitle: subtitle,
                          buttons: buttons,
                          buttonsLayoutType: .horizontal,
                          resultBlock: resultBlock)
        return view
    }

    ///  普通标题和副标题（可定义按钮布局）
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮标题
    ///   - buttonsLayoutType: 按钮布局样式
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(title: String,
                       subtitle: String,
                       buttons: [String]?,
                       buttonsLayoutType: BubbleButtonsLayoutType,
                       resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        var array: [BasicBubbleModel] = []

        if !title.isEmpty {
            let textModel = BubbleModelEditor.createTextBubbleModel(title: title, titleColor: "")
            array.append(textModel)
        }

        if !subtitle.isEmpty {
            let textModel = BubbleModelEditor.createTextBubbleModel(subtitle: subtitle, subtitleColor: "")
            array.append(textModel)
        }

        BubbleModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

        if let buttonsArray = buttons, !buttonsArray.isEmpty {
            let buttonsModel = BubbleModelEditor.createButtonsBubbleModel(buttons: buttonsArray,
                                                                          buttonsLayoutType: buttonsLayoutType)
            array.append(buttonsModel)
        }

        let view = BubbleView()
        view.configBubbleView(bubbleModels: array)
        view.bubbleResult = resultBlock
        return view
    }

    /// 普通标题和副标题（副标题是富文本）
    /// - Parameters:
    ///   - title: 主标题
    ///   - attributedSubtitle: 富文本副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(title: String,
                       attributedSubtitle: NSAttributedString?,
                       buttons: [String]?,
                       resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        var array: [BasicBubbleModel] = []

        if !title.isEmpty {
            let textModel = BubbleModelEditor.createTextBubbleModel(title: title, titleColor: "")
            array.append(textModel)
        }

        if let attributedSubText = attributedSubtitle, !attributedSubText.string.isEmpty {
            let textModel = BubbleModelEditor.createTextBubbleModel(attributedSubtitle: attributedSubText, subtitleColor: "")
            array.append(textModel)
        }

        BubbleModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

        if let buttonsArray = buttons, !buttonsArray.isEmpty {
            let buttonsModel = BubbleModelEditor.createButtonsBubbleModel(buttons: buttonsArray)
            array.append(buttonsModel)
        }

        let view = BubbleView()
        view.configBubbleView(bubbleModels: array)
        view.bubbleResult = resultBlock
        return view
    }
}
