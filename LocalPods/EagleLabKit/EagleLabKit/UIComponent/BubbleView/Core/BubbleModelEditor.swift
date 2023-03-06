//
//  BubbleModelEditor.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/23.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class BubbleModelEditor {
    static let bubbleLeftGap: CGFloat = BubbleConfig.pattern().leftGap
    static let bubbleRightGap: CGFloat = BubbleConfig.pattern().rightGap
    static let bubbleTopGapWithTile: CGFloat = BubbleConfig.pattern().topGapWithTile
    static let bubbleTopGapWithNoneTile: CGFloat = BubbleConfig.pattern().topGapWithNoneTile
    static let bubbleBottomGap: CGFloat = BubbleConfig.pattern().bottomGap
    static let bubbleVGap: CGFloat = BubbleConfig.pattern().verticalGap

    class func createTextBubbleModel(title: String, titleColor: String) -> TextBubbleModel {
        let textModel = TextBubbleModel()
        textModel.elementClassName = "TextBubbleElement"
        textModel.textContent = title
        textModel.textColor = !titleColor.isEmpty ? titleColor : BubbleConfig.commonColor()
        textModel.fontSize = 18.0
        textModel.bold = true

        /// 一行时候居中，超过两行的话居左显示
        let textWidth = BubbleView.contentWidth() - bubbleLeftGap - bubbleRightGap
        let lines = BubbleTextTool.calculateLines(text: title,
                                                  font: BubbleConfig.normalFont(ofSize: textModel.fontSize),
                                                  width: textWidth)
        let textAlignment = BubbleConfig.shared.bubbleLeftRightMirror ? NSTextAlignment.right : NSTextAlignment.left
        textModel.textAlignment = lines >= 2 ? textAlignment : NSTextAlignment.center

        return textModel
    }

    class func createTextBubbleModel(timeText: String) -> TextBubbleModel {
        let textModel = TextBubbleModel()
        textModel.elementClassName = "TextBubbleElement"
        textModel.textContent = timeText
        textModel.textColor = BubbleConfig.commonColor() + "99"
        textModel.fontSize = 16.0
        textModel.textAlignment = NSTextAlignment.center
        textModel.bold = false
        return textModel
    }

    class func createTextBubbleModel(subtitle: String, subtitleColor: String) -> TextBubbleModel {
        let textModel = TextBubbleModel()
        textModel.elementClassName = "TextBubbleElement"
        textModel.textContent = subtitle
        textModel.textColor = !subtitleColor.isEmpty ? subtitleColor : BubbleConfig.commonColor()
        textModel.fontSize = 16.0
        textModel.bold = false

        /// 一行时候居中，超过两行的话居左显示
        let textWidth = BubbleView.contentWidth() - bubbleLeftGap - bubbleRightGap
        let lines = BubbleTextTool.calculateLines(text: subtitle,
                                                  font: BubbleConfig.normalFont(ofSize: textModel.fontSize),
                                                  width: textWidth)
        let textAlignment = BubbleConfig.shared.bubbleLeftRightMirror ? NSTextAlignment.right : NSTextAlignment.left
        textModel.textAlignment = lines >= 2 ? textAlignment : NSTextAlignment.center

        return textModel
    }

    class func createTextBubbleModel(attributedSubtitle: NSAttributedString, subtitleColor: String) -> TextBubbleModel {
        let textModel = TextBubbleModel()
        textModel.elementClassName = "TextBubbleElement"
        textModel.attributedTextContent = attributedSubtitle
        textModel.maxHeight = BubbleView.bubbleScreenHeight * 0.5
        textModel.scrollable = true
        return textModel
    }

    class func createButtonsBubbleModel(buttons: [String],
                                        buttonColors: [String]? = nil,
                                        buttonsLayoutType: BubbleButtonsLayoutType = BubbleConfig.shared.buttonsLayoutType) -> ButtonsBubbleModel {
        let buttonsModel = ButtonsBubbleModel()
        buttonsModel.elementClassName = "ButtonsBubbleElement"
        buttonsModel.buttonTitles = (BubbleConfig.shared.bubbleLeftRightMirror && buttonsLayoutType == .horizontal) ? buttons.reversed() : buttons
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
                        colors.append(BubbleConfig.hintColor())
                    } else {
                        colors.append(BubbleConfig.commonColor())
                    }
                case .vertical:
                    if index == 0 {
                        colors.append(BubbleConfig.hintColor())
                    } else {
                        colors.append(BubbleConfig.commonColor())
                    }
                }
            }
            buttonsModel.textColors = (BubbleConfig.shared.bubbleLeftRightMirror && buttonsLayoutType == .horizontal) ? colors.reversed() : colors
        }
        return buttonsModel
    }

    class func createTextFieldBubbleModel(bubbleInput: BubbleTextFieldInput) -> TextFieldBubbleModel {
        let textFieldModel = TextFieldBubbleModel()
        textFieldModel.elementClassName = "TextFieldBubbleElement"
        textFieldModel.textContent = bubbleInput.inputText
        textFieldModel.placeHolderContent = bubbleInput.placeHolder
        textFieldModel.textColor = BubbleConfig.commonColor()
        textFieldModel.keyboardType = bubbleInput.keyboardType
        textFieldModel.tintColor = BubbleConfig.hintColor()
        textFieldModel.secureTextEntry = bubbleInput.secureTextEntry
        textFieldModel.clearButtonMode = bubbleInput.clearButtonMode
        return textFieldModel
    }

    class func createTextViewBubbleModel(bubbleInput: BubbleTextViewInput) -> TextViewBubbleModel {
        let textViewModel = TextViewBubbleModel()
        textViewModel.elementClassName = "TextViewBubbleElement"
        textViewModel.textContent = bubbleInput.inputText
        textViewModel.placeHolderContent = bubbleInput.placeHolder
        textViewModel.textColor = BubbleConfig.commonColor()
        textViewModel.keyboardType = bubbleInput.keyboardType
        textViewModel.tintColor = BubbleConfig.hintColor()
        textViewModel.maxTextLength = bubbleInput.maxTextLength
        return textViewModel
    }

    class func createImageBubbleModel(image: UIImage,
                                      imageSize: CGSize,
                                      imageFitWidth: Bool) -> ImageBubbleModel {
        let imageModel = ImageBubbleModel()
        imageModel.elementClassName = "ImageBubbleElement"
        imageModel.image = image
        imageModel.imageWidth = imageSize.width
        imageModel.imageHeight = imageSize.height
        imageModel.imageFitWidth = imageFitWidth
        return imageModel
    }

    class func createImageBubbleModel(imageUrl: String,
                                      placeholder: UIImage?,
                                      errorImage: UIImage?,
                                      imageSize: CGSize,
                                      imageFitWidth: Bool) -> ImageBubbleModel {
        let imageModel = ImageBubbleModel()
        imageModel.placeholder = placeholder
        imageModel.elementClassName = "ImageBubbleElement"
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

    class func createSelectorBubbleModel(items: [SelectorBubbleItem],
                                         maxSelectNum: Int,
                                         resultFromItemTap: Bool) -> SelectorBubbleModel {
        let selectorModel = SelectorBubbleModel()
        selectorModel.elementClassName = "SelectorBubbleElement"
        selectorModel.items = items

        let preference = SelectorPreference()
        preference.maxSelectNum = maxSelectNum
        preference.resultFromItemTap = resultFromItemTap
        selectorModel.preference = preference

        return selectorModel
    }

    class func createModelMargin(models: inout [BasicBubbleModel],
                                 existTitle: Bool) {
        // 统一设置 element margin
        for (index, model) in models.enumerated() {
            var top: CGFloat = 0.0
            var bottom: CGFloat = 0.0
            let topGap: CGFloat = existTitle ? bubbleTopGapWithTile : bubbleTopGapWithNoneTile
            if index == 0 {
                top = topGap
            }

            if model is TextFieldBubbleModel || model is TextViewBubbleModel {
                bottom = 0.0
            } else {
                bottom = (index == models.count - 1) ? bubbleBottomGap : bubbleVGap
            }
            model.margin = UIEdgeInsets(top: top, left: bubbleLeftGap, bottom: bottom, right: bubbleRightGap)
        }
    }
}
