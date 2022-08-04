//
//  Dialog+Input.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

// MARK: 自动显示弹框

extension EagleLabKit where Base: Dialog {
    /// 显示 textField 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textFieldInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func showDialog(title: String,
                           subtitle: String,
                           textFieldInput: DialogTextFieldInput,
                           buttons: [String]?,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
                          subtitle: subtitle,
                          textFieldInput: textFieldInput,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }

    /// 显示 textView 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textViewInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func showDialog(title: String,
                           subtitle: String,
                           textViewInput: DialogTextViewInput,
                           buttons: [String]?,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
                          subtitle: subtitle,
                          textViewInput: textViewInput,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension EagleLabKit where Base: Dialog {
    /// textField 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textFieldInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(title: String,
                       subtitle: String,
                       textFieldInput: DialogTextFieldInput,
                       buttons: [String]?,
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        var array: [BasicDialogModel] = []

        if !title.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(title: title, titleColor: "")
            array.append(textModel)
        }

        if !subtitle.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(subtitle: subtitle, subtitleColor: "")
            array.append(textModel)
        }

        let model = DialogModelEditor.createTextFieldDialogModel(dialogInput: textFieldInput)
        array.append(model)

        DialogModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

        if let buttonsArray = buttons, !buttonsArray.isEmpty {
            let buttonsModel = DialogModelEditor.createButtonsDialogModel(buttons: buttonsArray)
            array.append(buttonsModel)
        }

        let view = DialogView()
        view.configDialogView(dialogModels: array)
        view.dialogResult = resultBlock
        return view
    }

    /// textView 弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - textViewInput: 输入框配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(title: String,
                       subtitle: String,
                       textViewInput: DialogTextViewInput,
                       buttons: [String]?,
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        var array: [BasicDialogModel] = []

        if !title.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(title: title, titleColor: "")
            array.append(textModel)
        }

        if !subtitle.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(subtitle: subtitle, subtitleColor: "")
            array.append(textModel)
        }

        let model = DialogModelEditor.createTextViewDialogModel(dialogInput: textViewInput)
        array.append(model)

        DialogModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

        if let buttonsArray = buttons, !buttonsArray.isEmpty {
            let buttonsModel = DialogModelEditor.createButtonsDialogModel(buttons: buttonsArray)
            array.append(buttonsModel)
        }

        let view = DialogView()
        view.configDialogView(dialogModels: array)
        view.dialogResult = resultBlock
        return view
    }
}
