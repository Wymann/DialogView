//
//  Bubble+Input.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

// MARK: 自动显示弹框

extension Bubble {
    /// 显示 textField 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textFieldInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func showBubble(title: String,
                           subtitle: String,
                           textFieldInput: BubbleTextFieldInput,
                           buttons: [String]?,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          subtitle: subtitle,
                          textFieldInput: textFieldInput,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }

    /// 显示 textView 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textViewInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func showBubble(title: String,
                           subtitle: String,
                           textViewInput: BubbleTextViewInput,
                           buttons: [String]?,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          subtitle: subtitle,
                          textViewInput: textViewInput,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension Bubble {
    /// textField 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textFieldInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(title: String,
                       subtitle: String,
                       textFieldInput: BubbleTextFieldInput,
                       buttons: [String]?,
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

        let model = BubbleModelEditor.createTextFieldBubbleModel(bubbleInput: textFieldInput)
        array.append(model)

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

    /// textView 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textViewInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(title: String,
                       subtitle: String,
                       textViewInput: BubbleTextViewInput,
                       buttons: [String]?,
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

        let model = BubbleModelEditor.createTextViewBubbleModel(bubbleInput: textViewInput)
        array.append(model)

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
