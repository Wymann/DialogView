//
//  Dialog+SpecialColors.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

struct DialogSpecialColor {
    var titleColor: String = "" // 标题颜色
    var subtitleColor: String = "" // 副标题颜色
    var buttonColors: [String] = [] // 按钮颜色
}

struct DialogSubtitle {
    var subtitle: String = "" // 副标题
    var attributedSubtitle: NSAttributedString? // 富文本形式的副标题
}

// MARK: 自动显示弹框

extension EagleLabKit where Base: Dialog {
    /// 显示普通标题和副标题（非富文本）（颜色自定义）
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（非富文本）
    ///   - buttons: 按钮
    ///   - specialColor: 文字颜色配置
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(title: String,
                           subtitle: String,
                           buttons: [String]?,
                           specialColor: DialogSpecialColor,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
                          subtitle: DialogSubtitle(subtitle: subtitle),
                          buttons: buttons,
                          specialColor: specialColor,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }

    /// 显示普通标题和副标题（富文本）（颜色自定义）
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedSubtitle: 副标题（富文本）
    ///   - buttons: 按钮
    ///   - specialColor: 文字颜色配置
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(title: String,
                           attributedSubtitle: NSAttributedString,
                           buttons: [String]?,
                           specialColor: DialogSpecialColor,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
                          subtitle: DialogSubtitle(attributedSubtitle: attributedSubtitle),
                          buttons: buttons,
                          specialColor: specialColor,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension EagleLabKit where Base: Dialog {
    /// 自定义各种文字颜色的弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - buttons: 按钮
    ///   - specialColor: 文字颜色配置
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(title: String,
                       subtitle: DialogSubtitle,
                       buttons: [String]?,
                       specialColor: DialogSpecialColor,
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        var array: [BasicDialogModel] = []

        if !title.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(title: title,
                                                                    titleColor: specialColor.titleColor)
            array.append(textModel)
        }

        if !subtitle.subtitle.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(subtitle: subtitle.subtitle,
                                                                    subtitleColor: specialColor.subtitleColor)
            array.append(textModel)
        } else if let attributedSubText = subtitle.attributedSubtitle, !attributedSubText.string.isEmpty {
            let textModel = DialogModelEditor.createTextDialogModel(attributedSubtitle: attributedSubText, subtitleColor: "")
            array.append(textModel)
        }

        DialogModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

        if let buttonsArray = buttons, !buttonsArray.isEmpty {
            let buttonsModel = DialogModelEditor.createButtonsDialogModel(buttons: buttonsArray,
                                                                          buttonColors: specialColor.buttonColors)
            array.append(buttonsModel)
        }

        let view = DialogView()
        view.configDialogView(dialogModels: array)
        view.dialogResult = resultBlock
        return view
    }
}
