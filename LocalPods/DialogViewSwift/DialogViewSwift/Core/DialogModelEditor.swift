//
//  DialogModelEditor.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/23.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class DialogModelEditor {
    public static let dialogLeftGap: CGFloat = DialogConfig.pattern().leftGap
    public static let dialogRightGap: CGFloat = DialogConfig.pattern().rightGap
    public static let dialogTopGapWithTile: CGFloat = DialogConfig.pattern().topGapWithTile
    public static let dialogTopGapWithNoneTile: CGFloat = DialogConfig.pattern().topGapWithNoneTile
    public static let dialogBottomGap: CGFloat = DialogConfig.pattern().bottomGap
    public static let dialogVGap: CGFloat = DialogConfig.pattern().verticalGap

    public class func createTextDialogModel(title: String, titleColor: String) -> TextDialogModel {
        let textModel = TextDialogModel()
        textModel.elementClassName = "TextDialogElement"
        textModel.textContent = title
        textModel.textColor = !titleColor.isEmpty ? titleColor : DialogConfig.commonColor()
        textModel.fontSize = 18.0
        textModel.bold = true

        /// 一行时候居中，超过两行的话居左显示
        let textWidth = DialogView.contentWidth() - dialogLeftGap - dialogRightGap
        let lines = DialogTextTool.calculateLines(text: title,
                                                  font: DialogConfig.normalFont(ofSize: textModel.fontSize),
                                                  width: textWidth)
        textModel.textAlignment = lines >= 2 ? NSTextAlignment.left : NSTextAlignment.center

        return textModel
    }

    public class func createTextDialogModel(timeText: String) -> TextDialogModel {
        let textModel = TextDialogModel()
        textModel.elementClassName = "TextDialogElement"
        textModel.textContent = timeText
        textModel.textColor = DialogConfig.commonColor() + "99"
        textModel.fontSize = 16.0
        textModel.textAlignment = NSTextAlignment.center
        textModel.bold = false
        return textModel
    }

    public class func createTextDialogModel(subtitle: String, subtitleColor: String) -> TextDialogModel {
        let textModel = TextDialogModel()
        textModel.elementClassName = "TextDialogElement"
        textModel.textContent = subtitle
        textModel.textColor = !subtitleColor.isEmpty ? subtitleColor : DialogConfig.commonColor()
        textModel.fontSize = 16.0
        textModel.bold = false

        /// 一行时候居中，超过两行的话居左显示
        let textWidth = DialogView.contentWidth() - dialogLeftGap - dialogRightGap
        let lines = DialogTextTool.calculateLines(text: subtitle,
                                                  font: DialogConfig.normalFont(ofSize: textModel.fontSize),
                                                  width: textWidth)
        textModel.textAlignment = lines >= 2 ? NSTextAlignment.left : NSTextAlignment.center

        return textModel
    }

    public class func createTextDialogModel(attributedSubtitle: NSAttributedString, subtitleColor: String) -> TextDialogModel {
        let textModel = TextDialogModel()
        textModel.elementClassName = "TextDialogElement"
        textModel.attributedTextContent = attributedSubtitle
        textModel.maxHeight = DialogView.dialogScreenHeight * 0.5
        textModel.scrollable = true
        return textModel
    }

    public class func createButtonsDialogModel(buttons: [String],
                                               buttonColors: [String]? = nil,
                                               buttonsLayoutType: DialogButtonsLayoutType = DialogConfig.shared.buttonsLayoutType) -> ButtonsDialogModel {
        let buttonsModel = ButtonsDialogModel()
        buttonsModel.elementClassName = "ButtonsDialogElement"
        buttonsModel.buttonTitles = buttons
        buttonsModel.fontSize = 16.0
        buttonsModel.layoutType = buttonsLayoutType
        if let buttonColors = buttonColors, !buttonColors.isEmpty {
            buttonsModel.textColors = buttonColors
        } else if !buttons.isEmpty {
            var colors: [String] = []
            for index in 0 ..< buttons.count {
                switch buttonsLayoutType {
                case .horizontal:
                    if index == buttons.count - 1 {
                        colors.append(DialogConfig.hintColor())
                    } else {
                        colors.append(DialogConfig.commonColor())
                    }
                case .vertical:
                    if index == 0 {
                        colors.append(DialogConfig.hintColor())
                    } else {
                        colors.append(DialogConfig.commonColor())
                    }
                }
            }
            buttonsModel.textColors = colors
        }
        return buttonsModel
    }

    public class func createTextFieldDialogModel(dialogInput: DialogTextFieldInput) -> TextFieldDialogModel {
        let textFieldModel = TextFieldDialogModel()
        textFieldModel.elementClassName = "TextFieldDialogElement"
        textFieldModel.textContent = dialogInput.inputText
        textFieldModel.placeHolderContent = dialogInput.placeHolder
        textFieldModel.textColor = DialogConfig.commonColor()
        textFieldModel.keyboardType = dialogInput.keyboardType
        textFieldModel.tintColor = DialogConfig.hintColor()
        textFieldModel.secureTextEntry = dialogInput.secureTextEntry
        textFieldModel.clearButtonMode = dialogInput.clearButtonMode
        return textFieldModel
    }

    public class func createTextViewDialogModel(dialogInput: DialogTextViewInput) -> TextViewDialogModel {
        let textViewModel = TextViewDialogModel()
        textViewModel.elementClassName = "TextViewDialogElement"
        textViewModel.textContent = dialogInput.inputText
        textViewModel.placeHolderContent = dialogInput.placeHolder
        textViewModel.textColor = DialogConfig.commonColor()
        textViewModel.keyboardType = dialogInput.keyboardType
        textViewModel.tintColor = DialogConfig.hintColor()
        textViewModel.maxTextLength = dialogInput.maxTextLength
        return textViewModel
    }

    public class func createImageDialogModel(image: UIImage,
                                             imageSize: CGSize,
                                             imageFitWidth: Bool) -> ImageDialogModel {
        let imageModel = ImageDialogModel()
        imageModel.elementClassName = "ImageDialogElement"
        imageModel.image = image
        imageModel.imageWidth = imageSize.width
        imageModel.imageHeight = imageSize.height
        imageModel.imageFitWidth = imageFitWidth
        return imageModel
    }

    public class func createImageDialogModel(imageUrl: String,
                                             placeholder: UIImage?,
                                             errorImage: UIImage?,
                                             imageSize: CGSize,
                                             imageFitWidth: Bool) -> ImageDialogModel {
        let imageModel = ImageDialogModel()
        imageModel.placeholder = placeholder
        imageModel.elementClassName = "ImageDialogElement"
        imageModel.imageUrl = imageUrl
        imageModel.imageWidth = imageSize.width
        imageModel.imageHeight = imageSize.height
        imageModel.imageFitWidth = imageFitWidth
        imageModel.errorImage = errorImage

        if !imageUrl.isEmpty {
            imageModel.contentMode = UIView.ContentMode.scaleAspectFit
            imageModel.imageBackColor = "#2B2E2F"
        }

        return imageModel
    }

    public class func createSelectorDialogModel(items: [SelectorDialogItem],
                                                maxSelectNum: Int,
                                                resultFromItemTap: Bool) -> SelectorDialogModel {
        let selectorModel = SelectorDialogModel()
        selectorModel.elementClassName = "SelectorDialogElement"
        selectorModel.items = items

        let preference = SelectorPreference()
        preference.maxSelectNum = maxSelectNum
        preference.resultFromItemTap = resultFromItemTap
        selectorModel.preference = preference

        return selectorModel
    }

    public class func createModelMargin(models: inout [BasicDialogModel],
                                        existTitle: Bool) {
        // 统一设置 element margin
        for (index, model) in models.enumerated() {
            var top: CGFloat = 0.0
            var bottom: CGFloat = 0.0
            let topGap: CGFloat = existTitle ? dialogTopGapWithTile : dialogTopGapWithNoneTile
            if index == 0 {
                top = topGap
            }

            if model is TextFieldDialogModel || model is TextViewDialogModel {
                bottom = 0.0
            } else {
                bottom = (index == models.count - 1) ? dialogBottomGap : dialogVGap
            }
            model.margin = UIEdgeInsets(top: top, left: dialogLeftGap, bottom: bottom, right: dialogRightGap)
        }
    }
}
