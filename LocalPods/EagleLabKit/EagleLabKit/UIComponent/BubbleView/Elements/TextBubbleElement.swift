//
//  TextBubbleElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/22.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class TextBubbleElement: BasicBubbleElement {
    static let defaultElementTextColor: String = "#000000" // 默认文本颜色
    static let defaultElementFontSize: CGFloat = 16.0 // 默认字体大小
    static let defaultElementHeight: CGFloat = 40.0 // 默认高度
    static let defaultElementLineSpace: CGFloat = 5.0 // 默认行间距

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        return textLabel
    }()

    override func setUpDetailBubbleElement() {
        super.setUpDetailBubbleElement()
        if let textModel = model as? TextBubbleModel {
            layoutTextElement(textModel: textModel)
        }
    }

    private func layoutTextElement(textModel: TextBubbleModel) {
        textLabel.numberOfLines = textModel.maxLines
        if !textModel.attributedTextContent.string.isEmpty || !textModel.textContent.isEmpty {
            var attributedText: NSAttributedString = .init()

            if !textModel.attributedTextContent.string.isEmpty {
                attributedText = textModel.attributedTextContent
            } else {
                let textColor = !textModel.textColor.isEmpty ? textModel.textColor : TextBubbleElement.defaultElementTextColor
                let fontSize = textModel.fontSize > 0 ? textModel.fontSize : TextBubbleElement.defaultElementFontSize
                let lineSpace = textModel.lineSpace > 0 ? textModel.lineSpace : TextBubbleElement.defaultElementLineSpace

                if textModel.bold {
                    let range: [Int] = [0, textModel.textContent.count]
                    let fontRich: [String: Any] = ["richType": "font", "range": range, "fontSize": fontSize, "bold": true]
                    textModel.richText.append(fontRich)
                }

                var configuration = BubbleTextTool.AttributedStringConfig()
                configuration.textContent = textModel.textContent
                configuration.textAlignment = textModel.textAlignment
                configuration.fontSize = fontSize
                configuration.lineSpace = lineSpace
                configuration.textColor = UIColor(hexString: textColor) ?? UIColor.black
                configuration.richTextArray = textModel.richText
                let attributedString = BubbleTextTool.createAttributedString(configuration: configuration)

                attributedText = attributedString
            }

            textLabel.attributedText = attributedText

            let textContainerX = textModel.textEdgeInsets.left
            let textContainerY = textModel.textEdgeInsets.top
            let textContainerW = frame.width - textModel.textEdgeInsets.left - textModel.textEdgeInsets.right
            let textContainerH = frame.height - textModel.textEdgeInsets.top - textModel.textEdgeInsets.bottom
            let textHeight = UILabel.elk.labelHeight(attributed: attributedText, width: textContainerW, maxLines: textModel.maxLines)

            if textModel.maxHeight > 0.0, textModel.scrollable, textModel.maxHeight < textHeight {
                scrollView.frame = CGRect(x: textContainerX, y: textContainerY, width: textContainerW, height: textContainerH)
                scrollView.contentSize = CGSize(width: textContainerW, height: textHeight)
                addSubview(scrollView)

                textLabel.frame = CGRect(x: 0, y: 0, width: textContainerW, height: textHeight)
                scrollView.addSubview(textLabel)
            } else {
                textLabel.frame = CGRect(x: textContainerX, y: textContainerY, width: textContainerW, height: textContainerH)
                addSubview(textLabel)
            }
        }
    }

    override class func elementHeight(model: BasicBubbleModel, elementWidth: CGFloat) -> CGFloat {
        if let textModel = model as? TextBubbleModel {
            let width: CGFloat = elementWidth - textModel.textEdgeInsets.left - textModel.textEdgeInsets.right
            var height: CGFloat = 0.0

            if !textModel.attributedTextContent.string.isEmpty {
                height = UILabel.elk.labelHeight(attributed: textModel.attributedTextContent, width: width, maxLines: textModel.maxLines)
                height += (textModel.textEdgeInsets.top + textModel.textEdgeInsets.bottom)
            } else if !textModel.textContent.isEmpty {
                let textColor = !textModel.textColor.isEmpty ? textModel.textColor : defaultElementTextColor
                let fontSize = textModel.fontSize > 0 ? textModel.fontSize : defaultElementFontSize
                let lineSpace = textModel.lineSpace > 0 ? textModel.lineSpace : defaultElementLineSpace

                var configuration = BubbleTextTool.AttributedStringConfig()
                configuration.textContent = textModel.textContent
                configuration.textAlignment = textModel.textAlignment
                configuration.fontSize = fontSize
                configuration.lineSpace = lineSpace
                configuration.textColor = UIColor(hexString: textColor) ?? UIColor.black
                configuration.richTextArray = textModel.richText
                let attributedString = BubbleTextTool.createAttributedString(configuration: configuration)

                height = UILabel.elk.labelHeight(attributed: attributedString, width: width, maxLines: textModel.maxLines)
                height += (textModel.textEdgeInsets.top + textModel.textEdgeInsets.bottom)
            } else {
                height = defaultElementHeight
            }

            if textModel.maxHeight > 0, textModel.maxHeight < height {
                height = textModel.maxHeight
            }

            return height
        } else {
            return 0.0
        }
    }
}
