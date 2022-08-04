//
//  ButtonsDialogElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class ButtonsDialogElement: BasicDialogElement {
    static let dialogButtonHeight: CGFloat = 56.0

    private let dialogButtonDefaultFontSize: CGFloat = 15.0 // 默认字体大小

    private let dialogButtonLineHeight: CGFloat = 0.5

    private let basicButtonTag: Int = 777

    private let dialogButtonDefaultColor: String = "#000000"

    private let dialogButtonLineColor: String = "#DDDDDD"

    typealias ButtonClick = (_ buttonIndex: Int) -> Void // 点击按钮

    var clickBlock: ButtonClick?

    override func setUpDetailDialogElement() {
        super.setUpDetailDialogElement()
        if let buttonsModel = model as? ButtonsDialogModel {
            switch buttonsModel.layoutType {
            case .horizontal: layoutHorizontalButtons(buttonsModel: buttonsModel)
            case .vertical: layoutVerticalButtons(buttonsModel: buttonsModel)
            }
        }
    }

    private func layoutVerticalButtons(buttonsModel: ButtonsDialogModel) {
        let fontSize: CGFloat = buttonsModel.fontSize > 0.0 ? buttonsModel.fontSize : dialogButtonDefaultFontSize
        let buttonWidth: CGFloat = frame.width

        for (index, text) in buttonsModel.buttonTitles.enumerated() {
            var textColor = ""
            if buttonsModel.textColors.count > index {
                textColor = buttonsModel.textColors[index]
            } else {
                textColor = dialogButtonDefaultColor
            }

            let button = UIButton(type: UIButton.ButtonType.custom)
            button.frame = CGRect(x: 0, y: CGFloat(index) * ButtonsDialogElement.dialogButtonHeight, width: buttonWidth, height: ButtonsDialogElement.dialogButtonHeight)
            button.setTitle(text, for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor), for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor + "80"), for: UIControl.State.highlighted)
            button.setTitleColor(UIColor(hexString: textColor + "4D"), for: UIControl.State.disabled)
            button.titleLabel?.font = buttonsModel.bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
            addSubview(button)
            button.tag = basicButtonTag + index

            button.addTarget(self, action: #selector(clickButton(sender:)), for: UIControl.Event.touchUpInside)

            if index != buttonsModel.buttonTitles.count - 1 {
                let bottomLine = CALayer()
                bottomLine.frame = CGRect(x: 0.0, y: floor(ButtonsDialogElement.dialogButtonHeight - dialogButtonLineHeight), width: button.frame.width, height: dialogButtonLineHeight)
                bottomLine.backgroundColor = UIColor(hexString: dialogButtonLineColor)?.cgColor
                button.layer.addSublayer(bottomLine)

                if index == 0 {
                    let topLine = CALayer()
                    topLine.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: dialogButtonLineHeight)
                    topLine.backgroundColor = UIColor(hexString: dialogButtonLineColor)?.cgColor
                    button.layer.addSublayer(topLine)
                }
            }
        }
    }

    private func layoutHorizontalButtons(buttonsModel: ButtonsDialogModel) {
        let fontSize: CGFloat = buttonsModel.fontSize > 0.0 ? buttonsModel.fontSize : dialogButtonDefaultFontSize
        let buttonWidth: CGFloat = frame.width / CGFloat(buttonsModel.buttonTitles.count)

        for (index, text) in buttonsModel.buttonTitles.enumerated() {
            var textColor = ""
            if buttonsModel.textColors.count > index {
                textColor = buttonsModel.textColors[index]
            } else {
                textColor = dialogButtonDefaultColor
            }

            let button = UIButton(type: UIButton.ButtonType.custom)
            button.frame = CGRect(x: floor(CGFloat(index) * buttonWidth), y: 0, width: buttonWidth, height: ButtonsDialogElement.dialogButtonHeight)
            button.setTitle(text, for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor), for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor + "80"), for: UIControl.State.highlighted)
            button.setTitleColor(UIColor(hexString: textColor + "4D"), for: UIControl.State.disabled)
            button.titleLabel?.font = buttonsModel.bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
            addSubview(button)
            button.tag = basicButtonTag + index

            button.addTarget(self, action: #selector(clickButton(sender:)), for: UIControl.Event.touchUpInside)

            if index != buttonsModel.buttonTitles.count - 1 {
                let rightLine = CALayer()
                rightLine.frame = CGRect(x: floor(buttonWidth - dialogButtonLineHeight), y: 0.0, width: dialogButtonLineHeight, height: ButtonsDialogElement.dialogButtonHeight)
                rightLine.backgroundColor = UIColor(hexString: dialogButtonLineColor)?.cgColor
                button.layer.addSublayer(rightLine)
            }
        }

        let topLine = CALayer()
        topLine.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: dialogButtonLineHeight)
        topLine.backgroundColor = UIColor(hexString: dialogButtonLineColor)?.cgColor
        layer.addSublayer(topLine)
    }

    @objc private func clickButton(sender: UIButton) {
        if let block = clickBlock {
            block(sender.tag - basicButtonTag)
        }
    }

    public func enableButton(buttonIndex: Int) {
        let button: UIButton? = viewWithTag(buttonIndex + basicButtonTag) as? UIButton
        button?.isEnabled = true
    }

    public func disableButton(buttonIndex: Int) {
        let button: UIButton? = viewWithTag(buttonIndex + basicButtonTag) as? UIButton
        button?.isEnabled = false
    }

    override class func elementHeight(model: BasicDialogModel, elementWidth: CGFloat) -> CGFloat {
        guard let buttonsModel = model as? ButtonsDialogModel else {
            return 0.0
        }

        switch buttonsModel.layoutType {
        case .horizontal: return dialogButtonHeight
        case .vertical:
            if !buttonsModel.buttonTitles.isEmpty {
                return dialogButtonHeight * CGFloat(buttonsModel.buttonTitles.count)
            } else {
                return dialogButtonHeight
            }
        }
    }
}
