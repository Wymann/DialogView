//
//  BubbleView.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class BubbleView: UIView {
    static let bubbleScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let bubbleScreenHeight: CGFloat = UIScreen.main.bounds.size.height

    typealias BubbleViewShow = () -> Void // 显示
    typealias BubbleViewDisappear = (_ stayInQueue: Bool) -> Void // 消失（有可能还在队列中，谨慎使用）
    typealias BubbleViewRemoveFromQueue = () -> Void // 从队列移除
    typealias BubbleViewResult = (_ result: BubbleResult) -> Bool // 点击按钮结果

    // TextField 输入框即将输入文字。传回 TextShouldChange
    typealias BubbleViewTextFieldShouldChange = (_ textField: UITextField, _ changeRange: NSRange, _ replacementText: String) -> TextShouldChange
    // TextField 输入框已经输入文字。传回 String 为nil或者为空字符串则清空提示
    typealias BubbleViewTextFieldDidChange = (_ textField: UITextField) -> String?
    // TextView 输入框即将输入文字。传回 TextShouldChange
    typealias BubbleViewTextViewShouldChange = (_ textView: UITextView, _ changeRange: NSRange, _ replacementText: String) -> TextShouldChange
    // TextView 输入框已经输入文字。传回 String 为nil或者为空字符串则清空提示
    typealias BubbleViewTextViewDidChange = (_ textView: UITextView) -> String?

    var bubbleResult: BubbleViewResult?
    var bubbleTextFieldShouldChange: BubbleViewTextFieldShouldChange?
    var bubbleTextFieldDidChange: BubbleViewTextFieldDidChange?
    var bubbleTextViewShouldChange: BubbleViewTextViewShouldChange?
    var bubbleTextViewDidChange: BubbleViewTextViewDidChange?

    var showBlocks: [BubbleViewShow] = []
    var removeFromQueueBlocks: [BubbleViewRemoveFromQueue] = []
    var disappearBlocks: [BubbleViewDisappear] = []
    var mainRemoveFromQueueBlock: BubbleViewRemoveFromQueue?

    let dataModel = BubbleViewModel()

    private var keyWindowObservation: NSKeyValueObservation?

    // 主内容视图
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        return contentView
    }()

    private lazy var result: BubbleResult = {
        let result = BubbleResult()
        result.bubbleView = self
        return result
    }()

    // MARK: Configuration

    func configBubbleView(bubbleModels: [Any], configuration: BubbleViewConfig = .default) {
        dataModel.bubbleModels = bubbleModels
        dataModel.configuration = configuration
        commonConfig()
    }

    func configBubbleViewByCustomHeight(customView: UIView,
                                        customViewHeight: CGFloat,
                                        configuration: BubbleViewConfig = .default) {
        dataModel.customView = customView
        dataModel.customViewWidth = BubbleView.contentWidth()
        dataModel.customViewHeight = customViewHeight
        dataModel.configuration = configuration
        commonConfig()
    }

    func configBubbleViewByCustomSize(customView: UIView,
                                      customViewSize: CGSize,
                                      configuration: BubbleViewConfig = .default) {
        dataModel.customView = customView
        dataModel.customViewWidth = customViewSize.width
        dataModel.customViewHeight = customViewSize.height
        dataModel.configuration = configuration
        commonConfig()
    }

    static func contentWidth() -> CGFloat {
        let width: CGFloat = bubbleScreenWidth < bubbleScreenHeight ? bubbleScreenWidth : bubbleScreenHeight
        return width - BubbleConfig.pattern().bubbleLeftRightMargin * 2
    }

    lazy var keyWindow: UIWindow? = {
        var keyWindow = UIApplication.shared.keyWindow
        if keyWindow == nil {
            keyWindow = UIApplication.shared.windows.last
        }
        return keyWindow
    }()

    private func commonConfig() {
        frame = CGRect(x: 0,
                       y: 0,
                       width: BubbleView.bubbleScreenWidth,
                       height: BubbleView.bubbleScreenHeight)
        keyWindow?.addSubview(self)
        setUpDetailUI()
        createGestureRecognizer()
        keyWindowObservation = keyWindow?.observe(\.rootViewController, options: .new, changeHandler: { window, _ in
            window.bringSubviewToFront(self)
        })
    }

    // MARK: UI & Data

    private func setUpDetailUI() {
        bubbleBecomeFirstResponder()

        // 内容宽度
        if let unwrappedCustomView = dataModel.customView {
            dataModel.contentViewWidth = dataModel.customViewWidth
            dataModel.contentViewHeight = dataModel.customViewHeight
            unwrappedCustomView.frame = CGRect(x: 0, y: 0, width: dataModel.contentViewWidth, height: dataModel.contentViewHeight)
            contentView.addSubview(unwrappedCustomView)
            contentView.backgroundColor = UIColor.clear
        } else {
            dataModel.contentViewWidth = BubbleView.contentWidth()
            contentView.backgroundColor = UIColor.white
            contentView.layer.cornerRadius = BubbleConfig.pattern().cornerRadius
            contentView.clipsToBounds = true

            var elementY: CGFloat = 0

            // 布局
            if let unwrappedBubbleModels = dataModel.bubbleModels {
                for object in unwrappedBubbleModels {
                    if let model = object as? BasicBubbleModel {
                        if model.elementClassName.isEmpty { continue }

                        if let aClass = BubbleClassTool.getClass(classString: model.elementClassName) as? BasicBubbleElement.Type {
                            let elementW: CGFloat = dataModel.contentViewWidth - model.margin.left - model.margin.right
                            let height: CGFloat = aClass.elementHeight(model: model, elementWidth: elementW)
                            let elementX = model.margin.left
                            elementY += model.margin.top
                            let elementH: CGFloat = ceil(height)

                            let element: BasicBubbleElement = aClass.init()
                            element.frame = CGRect(x: elementX, y: elementY, width: elementW, height: elementH)
                            element.model = model
                            contentView.addSubview(element)

                            configSpecialElement(element: element, model: model)

                            elementY += (elementH + model.margin.bottom)
                        }
                    }
                }
            }
            dataModel.contentViewHeight = elementY
        }

        backgroundColor = dataModel.backStartColor
        dataModel.calculateFinalRect()
        dataModel.calculateStartRect()
        if dataModel.configuration.animation == .showNone {
            backgroundColor = dataModel.backFinalColor
            contentView.alpha = 1.0
        } else if dataModel.configuration.animation == .showFade {
            contentView.alpha = 0.0
        }
        contentView.frame = dataModel.startRect
        addSubview(contentView)
    }

    private func configSpecialElement(element: BasicBubbleElement, model: BasicBubbleModel) {
        if model.elementClassName == "ButtonsBubbleElement" {
            if let unwrappedButtonsElement = element as? ButtonsBubbleElement,
               let unwrappedButtonModel = model as? ButtonsBubbleModel {
                dataModel.buttonsElement = unwrappedButtonsElement
                dataModel.buttonModel = unwrappedButtonModel

                unwrappedButtonsElement.clickBlock = { (_ buttonIndex: Int) in
                    self.clickOnButton(buttonIndex: buttonIndex)
                }
            }
        }

        if model.elementClassName == "TextFieldBubbleElement" {
            if let unwrappedTextFieldElement = element as? TextFieldBubbleElement {
                dataModel.textField = unwrappedTextFieldElement.textField
                dataModel.textField?.delegate = self
                dataModel.errorLabel = unwrappedTextFieldElement.errorLabel

                if dataModel.textField != nil {
                    addNotifications()
                }
            }
        }

        if model.elementClassName == "TextViewBubbleElement" {
            if let unwrappedTextViewElement = element as? TextViewBubbleElement {
                dataModel.textView = unwrappedTextViewElement.textView
                dataModel.errorLabel = unwrappedTextViewElement.errorLabel
                dataModel.maxLengthLabel = unwrappedTextViewElement.maxLengthLabel
                dataModel.textViewMaxLength = unwrappedTextViewElement.textViewMaxLength()
                dataModel.textView?.delegate = self

                if dataModel.textView != nil {
                    addNotifications()
                }
            }
        }

        if model.elementClassName == "SelectorBubbleElement" {
            if let unwrappedSelectorElement = element as? SelectorBubbleElement {
                dataModel.selectorElement = unwrappedSelectorElement
                unwrappedSelectorElement.resultBlock = { (_ selectedItems: [SelectorBubbleItem], _ selectedIndexes: [Int]) in
                    self.result.selectedItems = selectedItems
                    self.result.selectedIndexes = selectedIndexes

                    if let block = self.bubbleResult {
                        let close = block(self.result)
                        if close {
                            self.closeBubbleView()
                        }
                    }
                }
            }
        }
    }

    // MARK: Methods

    func showBubbleView() {
        isHidden = false
        contentView.alpha = dataModel.configuration.animation == .showFade ? 0.0 : 1.0
        superview?.bringSubviewToFront(self)

        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.dataModel.backFinalColor
            self.contentView.alpha = 1.0
        }

        if dataModel.configuration.bounce {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.5,
                           options: .layoutSubviews) {
                self.contentView.frame = self.dataModel.finalRect
            } completion: { _ in
                if !self.showBlocks.isEmpty {
                    for block in self.showBlocks {
                        block()
                    }
                }
            }

        } else {
            UIView.animate(withDuration: 0.3) {
                self.contentView.frame = self.dataModel.finalRect
            } completion: { _ in
                if !self.showBlocks.isEmpty {
                    for block in self.showBlocks {
                        block()
                    }
                }
            }
        }
    }

    func closeBubbleView() {
        closeBubbleView(animation: true, stayInQueue: false)
    }

    func closeBubbleView(stayInQueue: Bool) {
        closeBubbleView(animation: false, stayInQueue: stayInQueue)
    }

    func removeBubbleViewFromQueue() {
        removeFromSuperview()

        if !removeFromQueueBlocks.isEmpty {
            for block in removeFromQueueBlocks {
                block()
            }
        }

        if let unwrappedBlock = mainRemoveFromQueueBlock {
            unwrappedBlock()
        }
    }

    func closeBubbleView(animation: Bool, stayInQueue: Bool) {
        if dataModel.configuration.animation == .showNone || !animation {
            backgroundColor = dataModel.backStartColor
            contentView.frame = dataModel.startRect
            if dataModel.configuration.animation == .showFade {
                contentView.alpha = 0.0
            }

            finishedCloseBubbleView(stayInQueue: stayInQueue)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = self.dataModel.backStartColor
                self.contentView.frame = self.dataModel.startRect
                if self.dataModel.configuration.animation == .showFade {
                    self.contentView.alpha = 0.0
                }
            } completion: { _ in
                self.finishedCloseBubbleView(stayInQueue: stayInQueue)
            }
        }
    }

    func finishedCloseBubbleView(stayInQueue: Bool) {
        if stayInQueue {
            isHidden = true
            superview?.sendSubviewToBack(self)
        } else {
            removeFromSuperview()
        }

        if let unwrappedBlock = mainRemoveFromQueueBlock, !stayInQueue {
            unwrappedBlock()
        }

        if !disappearBlocks.isEmpty {
            for block in disappearBlocks {
                block(stayInQueue)
            }
        }
    }

    func bubbleBecomeFirstResponder() {
        if let unwrappedTextField = dataModel.textField {
            unwrappedTextField.becomeFirstResponder()
        }

        if let unwrappedTextView = dataModel.textView {
            unwrappedTextView.becomeFirstResponder()
        }
    }

    func bubbleResignFirstResponder() {
        if let unwrappedTextField = dataModel.textField {
            unwrappedTextField.resignFirstResponder()
        }

        if let unwrappedTextView = dataModel.textView {
            unwrappedTextView.resignFirstResponder()
        }
    }

    func sideTapEnable(enable: Bool) {
        dataModel.configuration.sideTap = enable
    }

    func enableButton(buttonIndex: Int) {
        dataModel.buttonsElement?.enableButton(buttonIndex: buttonIndex)
    }

    func disableButton(buttonIndex: Int) {
        dataModel.buttonsElement?.disableButton(buttonIndex: buttonIndex)
    }

    func addShowBlock(showBlock: @escaping BubbleViewShow) {
        showBlocks.append(showBlock)
    }

    func addDisappearBlock(disappearBlock: @escaping BubbleViewDisappear) {
        disappearBlocks.append(disappearBlock)
    }

    func addRemoveFromQueueBlock(removeFromQueueBlock: @escaping BubbleViewRemoveFromQueue) {
        removeFromQueueBlocks.append(removeFromQueueBlock)
    }

    func setUpMainRemoveFromQueueBlock(mainRemoveFromQueueBlock: @escaping BubbleViewRemoveFromQueue) {
        self.mainRemoveFromQueueBlock = mainRemoveFromQueueBlock
    }

    // MARK: Private Methods

    private func showErrorTips(errorTips: String) {
        dataModel.errorLabel?.text = errorTips
    }

    // MARK: Target Methods

    private func clickOnButton(buttonIndex: Int) {
        if let model = dataModel.buttonModel {
            result.buttonIndex = buttonIndex
            if buttonIndex >= 0 {
                var buttonTitle = ""
                if BubbleConfig.shared.bubbleLeftRightMirror, model.layoutType == .horizontal {
                    buttonTitle = model.buttonTitles.reversed()[buttonIndex]
                } else {
                    buttonTitle = model.buttonTitles[buttonIndex]
                }
                result.buttonTitle = buttonTitle
            } else {
                result.buttonTitle = "SideTap"
            }

            if let block = bubbleResult {
                if dataModel.textField != nil {
                    result.inputText = dataModel.textField?.text ?? ""
                } else if dataModel.textView != nil {
                    result.inputText = dataModel.textView?.text ?? ""
                }

                if let selector = dataModel.selectorElement {
                    result.selectedItems = selector.selectedItems()
                    result.selectedIndexes = selector.selectedIndexes
                }

                let close = block(result)
                if close {
                    closeBubbleView()
                }

            } else {
                closeBubbleView()
            }
        } else {
            closeBubbleView()
        }
    }

    private func createGestureRecognizer() {
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeTapClick(sender:)))
        closeTap.delegate = self
        addGestureRecognizer(closeTap)
        isUserInteractionEnabled = true
    }

    @objc private func closeTapClick(sender: UITapGestureRecognizer) {
        if dataModel.openedKeyboard {
            dataModel.textField?.resignFirstResponder()
            dataModel.textView?.resignFirstResponder()
            return
        }

        if dataModel.configuration.sideTap {
            clickOnButton(buttonIndex: -1)
        }
    }

    // MARK: Notifications

    private func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShowAction(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHideAction(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChanged(sender:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }

    @objc private func keyboardShowAction(sender: Notification) {
        dataModel.openedKeyboard = true

        guard let userInfo = sender.userInfo else {
            return
        }

        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat

        let keyBoardHeight = ceil(keyboardRect.height)

        if dataModel.finalRect.maxY > BubbleView.bubbleScreenHeight - keyBoardHeight {
            UIView.animate(withDuration: duration ?? 0.2) {
                var newRect = self.dataModel.finalRect
                newRect.origin.y = floor(BubbleView.bubbleScreenHeight - keyBoardHeight - self.dataModel.finalRect.height) - 24.0
                self.contentView.frame = newRect
            }
        }
    }

    @objc private func keyboardHideAction(sender: Notification) {
        dataModel.openedKeyboard = false
        UIView.animate(withDuration: 0.2) {
            self.contentView.frame = self.dataModel.finalRect
        }
    }

    @objc private func textFieldDidChanged(sender: Notification) {
        if let block = bubbleTextFieldDidChange, let unwrappedTextField = dataModel.textField {
            let errorString = block(unwrappedTextField)
            showErrorTips(errorTips: errorString ?? "")
        }
    }

    deinit {
        keyWindowObservation?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: UITextFieldDelegate

extension BubbleView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        result.inputText = textField.text ?? ""
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let block = bubbleTextFieldShouldChange, let unwrappedTextField = dataModel.textField {
            let model = block(unwrappedTextField, range, string)
            showErrorTips(errorTips: model.tip ?? "")
            return model.shouldChange
        } else {
            return true
        }
    }
}

// MARK: UITextViewDelegate

extension BubbleView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        result.inputText = textView.text ?? ""
    }

    func textViewDidChange(_ textView: UITextView) {
        if dataModel.textViewMaxLength > 0 {
            let toBeString: NSString = .init(string: textView.text)
            var position: UITextPosition?
            if let selectedRange = textView.markedTextRange {
                position = textView.position(from: selectedRange.start, offset: 0)
            }

            if position == nil {
                if toBeString.length > dataModel.textViewMaxLength {
                    let rangeIndex1 = toBeString.rangeOfComposedCharacterSequence(at: dataModel.textViewMaxLength)
                    if rangeIndex1.length == 1 {
                        textView.text = toBeString.substring(to: dataModel.textViewMaxLength)
                    } else {
                        let rangeIndex2 = toBeString.rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: dataModel.textViewMaxLength))
                        textView.text = toBeString.substring(with: rangeIndex2)
                    }
                    dataModel.maxLengthLabel?.text = "\(textView.text.count)" + "/" + "\(dataModel.textViewMaxLength)"
                } else {
                    dataModel.maxLengthLabel?.text = "\(textView.text.count)" + "/" + "\(dataModel.textViewMaxLength)"
                }
            }
        }

        result.inputText = textView.text
        if let block = bubbleTextViewDidChange, let unwrappedTextView = dataModel.textView {
            let errorString = block(unwrappedTextView)
            showErrorTips(errorTips: errorString ?? "")
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let block = bubbleTextViewShouldChange, let unwrappedTextView = dataModel.textView {
            let model = block(unwrappedTextView, range, text)
            showErrorTips(errorTips: model.tip ?? "")
            return model.shouldChange
        } else {
            return true
        }
    }
}

// MARK: UIGestureRecognizerDelegate

extension BubbleView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
}
