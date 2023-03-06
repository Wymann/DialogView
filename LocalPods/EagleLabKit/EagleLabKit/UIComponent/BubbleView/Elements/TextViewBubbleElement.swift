//
//  TextViewBubbleElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class TextViewBubbleElement: BasicBubbleElement {
    private let errorLabelHeight: CGFloat = 24.0
    private let defaultElementTextColor: String = "#000000" // 默认文本颜色
    private let defaultElementPlaceHolderColor: String = "#888888" // 占位文本颜色
    private let defaultElementLineColor: String = "#666666" // 默认线条颜色
    private let defaultElementFontSize: CGFloat = 14.0 // 默认字体大小
    private let maxLengthLabelHeight = 22.0
    private let maxLengthLabelBottomGap = 12.0

    lazy var textView: BubbleTextView = {
        let textView = BubbleTextView()
        textView.layer.cornerRadius = 4.0
        textView.clipsToBounds = true
        textView.backgroundColor = UIColor(hexString: "#F4F5F7")
        return textView
    }()

    lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = UIColor(hexString: "#FF4747")
        errorLabel.font = BubbleConfig.normalFont(ofSize: 12.0)
        return errorLabel
    }()

    lazy var maxLengthLabel: UILabel = {
        let maxLengthLabel = UILabel()
        maxLengthLabel.textColor = UIColor(hexString: BubbleConfig.commonColor() + "66")
        maxLengthLabel.font = BubbleConfig.normalFont(ofSize: 14.0)
        maxLengthLabel.textAlignment = NSTextAlignment.right
        return maxLengthLabel
    }()

    func textViewMaxLength() -> Int {
        if let textViewModel = model as? TextViewBubbleModel {
            return textViewModel.maxTextLength
        } else {
            return 0
        }
    }

    override func setUpDetailBubbleElement() {
        super.setUpDetailBubbleElement()

        if let textViewModel = model as? TextViewBubbleModel {
            layoutTextViewElement(textViewModel: textViewModel)
        }
    }

    private func layoutTextViewElement(textViewModel: TextViewBubbleModel) {
        let textViewX = textViewModel.textViewEdgeInsets.left
        let textViewY = textViewModel.textViewEdgeInsets.top
        let textViewW = frame.width - textViewModel.textViewEdgeInsets.left - textViewModel.textViewEdgeInsets.right
        let textViewH = frame.height - textViewModel.textViewEdgeInsets.top - textViewModel.textViewEdgeInsets.bottom - errorLabelHeight
        textView.frame = CGRect(x: textViewX, y: textViewY, width: textViewW, height: textViewH)
        addSubview(textView)

        let textColor = !textViewModel.textColor.isEmpty ? textViewModel.textColor : defaultElementTextColor
        let fontSize = textViewModel.fontSize > 0 ? textViewModel.fontSize : defaultElementFontSize

        textView.textColor = UIColor(hexString: textColor) ?? UIColor.darkGray
        textView.placeholder = textViewModel.placeHolderContent
        textView.placeholderColor = UIColor(hexString: defaultElementPlaceHolderColor) ?? UIColor.darkGray
        textView.text = textViewModel.textContent
        textView.textAlignment = textViewModel.textAlignment
        textView.font = BubbleConfig.normalFont(ofSize: fontSize)
        textView.keyboardType = textViewModel.keyboardType

        if textViewModel.maxTextLength > 0 {
            let bottom = maxLengthLabelHeight + maxLengthLabelBottomGap + 5.0
            textView.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: bottom, right: 5.0)
        } else {
            textView.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        }

        if !textViewModel.tintColor.isEmpty {
            textView.tintColor = UIColor(hexString: textViewModel.tintColor)
        }
        textView.isEditable = textViewModel.editable

        errorLabel.frame = CGRect(x: textViewX, y: textView.frame.maxY, width: textViewW, height: errorLabelHeight)
        addSubview(errorLabel)

        if textViewModel.maxTextLength > 0 {
            let backViewY = textView.frame.maxY - maxLengthLabelHeight - maxLengthLabelBottomGap
            let backViewW = textView.frame.width
            let backViewH = maxLengthLabelHeight + maxLengthLabelBottomGap + 1.0
            let backViewRect = CGRect(x: 0.0, y: backViewY, width: backViewW, height: backViewH)
            let backView = UIView(frame: backViewRect)
            backView.backgroundColor = textView.backgroundColor
            addSubview(backView)

            let maxLengthLabelW = backView.frame.width - 32.0
            maxLengthLabel.frame = CGRect(x: 16.0, y: 0.0, width: maxLengthLabelW, height: maxLengthLabelHeight)
            backView.addSubview(maxLengthLabel)
            let textCount = textViewModel.textContent.count
            let maxTextCount = textViewModel.maxTextLength
            maxLengthLabel.text = "\(textCount)" + "/" + "\(maxTextCount)"
        }
    }

    override class func elementHeight(model: BasicBubbleModel, elementWidth: CGFloat) -> CGFloat {
        if model is TextViewBubbleModel {
            return 144.0
        } else {
            return 0.0
        }
    }
}
