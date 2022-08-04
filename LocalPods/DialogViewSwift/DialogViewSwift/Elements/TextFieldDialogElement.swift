//
//  TextFieldDialogElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDialogElement: BasicDialogElement {
    private let errorLabelHeight: CGFloat = 24.0
    private let defaultElementTextColor: String = "#000000" // 默认文本颜色
    private let defaultElementLineColor: String = "#666666" // 默认线条颜色
    private let defaultElementFontSize: CGFloat = 16.0 // 默认字体大小

    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4.0
        textField.backgroundColor = UIColor(hexString: "#ECECEC")

        let leftView = UIView()
        var leftViewRect = CGRect.zero
        leftViewRect.size.width = 10
        leftView.frame = leftViewRect
        textField.leftView = leftView
        textField.leftViewMode = .always

        return textField
    }()

    public lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = UIColor(hexString: "#FF4747")
        errorLabel.font = UIFont.systemFont(ofSize: 12.0)

        return errorLabel
    }()

    override func setUpDetailDialogElement() {
        super.setUpDetailDialogElement()

        if let textFieldModel = model as? TextFieldDialogModel {
            layoutTextFieldElement(textFieldModel: textFieldModel)
        }
    }

    private func layoutTextFieldElement(textFieldModel: TextFieldDialogModel) {
        let textFieldX = textFieldModel.textFieldEdgeInsets.left
        let textFieldY = textFieldModel.textFieldEdgeInsets.top
        let textFieldW = frame.width - textFieldModel.textFieldEdgeInsets.left - textFieldModel.textFieldEdgeInsets.right
        let textFieldH = frame.height - textFieldModel.textFieldEdgeInsets.top - textFieldModel.textFieldEdgeInsets.bottom - errorLabelHeight
        textField.frame = CGRect(x: textFieldX, y: textFieldY, width: textFieldW, height: textFieldH)
        addSubview(textField)

        let textColor = !textFieldModel.textColor.isEmpty ? textFieldModel.textColor : defaultElementTextColor
        let fontSize = textFieldModel.fontSize > 0 ? textFieldModel.fontSize : defaultElementFontSize

        if !textFieldModel.placeHolderContent.isEmpty {
            let range = NSRange(location: 0, length: textFieldModel.placeHolderContent.count)
            let font = UIFont.systemFont(ofSize: fontSize)
            let color = UIColor(hexString: textColor + "80") ?? UIColor.darkGray

            let attributedPlaceholder = NSMutableAttributedString(string: textFieldModel.placeHolderContent)
            attributedPlaceholder.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            attributedPlaceholder.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

            textField.attributedPlaceholder = attributedPlaceholder
        }

        textField.textColor = UIColor(hexString: textColor) ?? UIColor.black
        textField.text = textFieldModel.textContent
        textField.textAlignment = textFieldModel.textAlignment
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.isSecureTextEntry = textFieldModel.secureTextEntry
        textField.clearButtonMode = textFieldModel.clearButtonMode
        textField.keyboardType = textFieldModel.keyboardType

        if !textFieldModel.tintColor.isEmpty {
            textField.tintColor = UIColor(hexString: textFieldModel.tintColor)
        }

        errorLabel.frame = CGRect(x: textFieldX, y: textField.frame.maxY, width: textFieldW, height: errorLabelHeight)
        addSubview(errorLabel)
    }

    override class func elementHeight(model: BasicDialogModel, elementWidth: CGFloat) -> CGFloat {
        if model is TextFieldDialogModel {
            return 68.0
        } else {
            return 0.0
        }
    }
}
