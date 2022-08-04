//
//  Dialog+Common.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/23.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

// MARK: 自动显示弹框

extension EagleLabKit where Base: Dialog {
    /// 显示普通标题和副标题
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(title: String,
                           subtitle: String,
                           buttons: [String]?,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title:
            title,
            subtitle:
            subtitle,
            buttons: buttons,
            resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }

    ///  显示普通标题和副标题（可定义按钮布局）
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮标题
    ///   - buttonsLayoutType: 按钮布局样式
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(title: String,
                           subtitle: String,
                           buttons: [String]?,
                           buttonsLayoutType: DialogButtonsLayoutType,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
                          subtitle: subtitle,
                          buttons: buttons,
                          buttonsLayoutType: buttonsLayoutType,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }

    /// 显示普通标题和副标题（副标题是富文本）
    /// - Parameters:
    ///   - title: 主标题
    ///   - attributedSubtitle: 富文本副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(title: String,
                           attributedSubtitle: NSAttributedString?,
                           buttons: [String]?,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
                          attributedSubtitle: attributedSubtitle,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension EagleLabKit where Base: Dialog {
    /// 普通标题和副标题
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(title: String,
                       subtitle: String,
                       buttons: [String]?,
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
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
    /// - Returns: DialogView
    static func dialog(title: String,
                       subtitle: String,
                       buttons: [String]?,
                       buttonsLayoutType: DialogButtonsLayoutType,
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

        DialogModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

        if let buttonsArray = buttons, !buttonsArray.isEmpty {
            let buttonsModel = DialogModelEditor.createButtonsDialogModel(buttons: buttonsArray,
                                                                          buttonsLayoutType: buttonsLayoutType)
            array.append(buttonsModel)
        }

        let view = DialogView()
        view.configDialogView(dialogModels: array)
        view.dialogResult = resultBlock
        return view
    }

    /// 普通标题和副标题（副标题是富文本）
    /// - Parameters:
    ///   - title: 主标题
    ///   - attributedSubtitle: 富文本副标题
    ///   - buttons: 按钮标题
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(title: String,
                       attributedSubtitle: NSAttributedString?,
                       buttons: [String]?,
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        var array: [BasicDialogModel] = []

        if !title.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(title: title, titleColor: "")
            array.append(textModel)
        }

        if let attributedSubText = attributedSubtitle, !attributedSubText.string.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(attributedSubtitle: attributedSubText, subtitleColor: "")
            array.append(textModel)
        }

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
