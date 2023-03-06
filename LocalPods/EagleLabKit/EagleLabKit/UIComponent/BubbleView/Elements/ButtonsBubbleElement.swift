//
//  ButtonsBubbleElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class ButtonsBubbleElement: BasicBubbleElement {
    static let bubbleButtonHeight: CGFloat = 56.0

    private let bubbleButtonDefaultFontSize: CGFloat = 15.0 // 默认字体大小

    private let bubbleButtonLineHeight: CGFloat = 0.5

    private let basicButtonTag: Int = 777

    private let bubbleButtonDefaultColor: String = "#000000"

    private let bubbleButtonLineColor: String = "#DDDDDD"

    typealias ButtonClick = (_ buttonIndex: Int) -> Void // 点击按钮

    var clickBlock: ButtonClick?

    override func setUpDetailBubbleElement() {
        super.setUpDetailBubbleElement()
        if let buttonsModel = model as? ButtonsBubbleModel {
            switch buttonsModel.layoutType {
            case .horizontal: layoutHorizontalButtons(buttonsModel: buttonsModel)
            case .vertical: layoutVerticalButtons(buttonsModel: buttonsModel)
            }
        }
    }

    private func layoutVerticalButtons(buttonsModel: ButtonsBubbleModel) {
        let fontSize: CGFloat = buttonsModel.fontSize > 0.0 ? buttonsModel.fontSize : bubbleButtonDefaultFontSize
        let buttonWidth: CGFloat = frame.width

        for (index, text) in buttonsModel.buttonTitles.enumerated() {
            var textColor = ""
            if buttonsModel.textColors.count > index {
                textColor = buttonsModel.textColors[index]
            } else {
                textColor = bubbleButtonDefaultColor
            }

            let button = UIButton(type: UIButton.ButtonType.custom)
            button.frame = CGRect(x: 0, y: CGFloat(index) * ButtonsBubbleElement.bubbleButtonHeight, width: buttonWidth, height: ButtonsBubbleElement.bubbleButtonHeight)
            button.setTitle(text, for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor), for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor + "80"), for: UIControl.State.highlighted)
            button.setTitleColor(UIColor(hexString: textColor + "4D"), for: UIControl.State.disabled)
            button.titleLabel?.font = buttonsModel.bold ? BubbleConfig.boldFont(ofSize: fontSize) : BubbleConfig.normalFont(ofSize: fontSize)
            addSubview(button)
            button.tag = basicButtonTag + index

            button.addTarget(self, action: #selector(clickButton(sender:)), for: UIControl.Event.touchUpInside)

            if index != buttonsModel.buttonTitles.count - 1 {
                let bottomLine = CALayer()
                bottomLine.frame = CGRect(x: 0.0, y: floor(ButtonsBubbleElement.bubbleButtonHeight - bubbleButtonLineHeight), width: button.frame.width, height: bubbleButtonLineHeight)
                bottomLine.backgroundColor = UIColor(hexString: bubbleButtonLineColor)?.cgColor
                button.layer.addSublayer(bottomLine)

                if index == 0 {
                    let topLine = CALayer()
                    topLine.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: bubbleButtonLineHeight)
                    topLine.backgroundColor = UIColor(hexString: bubbleButtonLineColor)?.cgColor
                    button.layer.addSublayer(topLine)
                }
            }
        }
    }

    private func layoutHorizontalButtons(buttonsModel: ButtonsBubbleModel) {
        let fontSize: CGFloat = buttonsModel.fontSize > 0.0 ? buttonsModel.fontSize : bubbleButtonDefaultFontSize
        let buttonWidth: CGFloat = frame.width / CGFloat(buttonsModel.buttonTitles.count)

        for (index, text) in buttonsModel.buttonTitles.enumerated() {
            var textColor = ""
            if buttonsModel.textColors.count > index {
                textColor = buttonsModel.textColors[index]
            } else {
                textColor = bubbleButtonDefaultColor
            }

            let button = UIButton(type: UIButton.ButtonType.custom)
            button.frame = CGRect(x: floor(CGFloat(index) * buttonWidth), y: 0, width: buttonWidth, height: ButtonsBubbleElement.bubbleButtonHeight)
            button.setTitle(text, for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor), for: UIControl.State.normal)
            button.setTitleColor(UIColor(hexString: textColor + "80"), for: UIControl.State.highlighted)
            button.setTitleColor(UIColor(hexString: textColor + "4D"), for: UIControl.State.disabled)
            button.titleLabel?.font = buttonsModel.bold ? BubbleConfig.boldFont(ofSize: fontSize) : BubbleConfig.normalFont(ofSize: fontSize)
            addSubview(button)
            let buttonTagIndex = BubbleConfig.shared.bubbleLeftRightMirror ? buttonsModel.buttonTitles.count - 1 - index : index
            button.tag = basicButtonTag + buttonTagIndex

            button.addTarget(self, action: #selector(clickButton(sender:)), for: UIControl.Event.touchUpInside)

            if index != buttonsModel.buttonTitles.count - 1 {
                let rightLine = CALayer()
                rightLine.frame = CGRect(x: floor(buttonWidth - bubbleButtonLineHeight), y: 0.0, width: bubbleButtonLineHeight, height: ButtonsBubbleElement.bubbleButtonHeight)
                rightLine.backgroundColor = UIColor(hexString: bubbleButtonLineColor)?.cgColor
                button.layer.addSublayer(rightLine)
            }
        }

        let topLine = CALayer()
        topLine.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: bubbleButtonLineHeight)
        topLine.backgroundColor = UIColor(hexString: bubbleButtonLineColor)?.cgColor
        layer.addSublayer(topLine)
    }

    @objc private func clickButton(sender: UIButton) {
        if let block = clickBlock {
            block(sender.tag - basicButtonTag)
        }
    }

    func enableButton(buttonIndex: Int) {
        let button: UIButton? = viewWithTag(buttonIndex + basicButtonTag) as? UIButton
        button?.isEnabled = true
    }

    func disableButton(buttonIndex: Int) {
        let button: UIButton? = viewWithTag(buttonIndex + basicButtonTag) as? UIButton
        button?.isEnabled = false
    }

    override class func elementHeight(model: BasicBubbleModel, elementWidth: CGFloat) -> CGFloat {
        guard let buttonsModel = model as? ButtonsBubbleModel else {
            return 0.0
        }

        switch buttonsModel.layoutType {
        case .horizontal: return bubbleButtonHeight
        case .vertical:
            if !buttonsModel.buttonTitles.isEmpty {
                return bubbleButtonHeight * CGFloat(buttonsModel.buttonTitles.count)
            } else {
                return bubbleButtonHeight
            }
        }
    }
}
