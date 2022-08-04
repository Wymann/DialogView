//
//  DialogView.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class DialogView: UIView, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    static let dialogScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let dialogScreenHeight: CGFloat = UIScreen.main.bounds.size.height

    typealias DialogViewShow = () -> Void // 显示
    typealias DialogViewDisappear = (_ stayInQueue: Bool) -> Void // 消失（有可能还在队列中，谨慎使用）
    typealias DialogViewRemoveFromQueue = () -> Void // 从队列移除
    typealias DialogViewResult = (_ result: DialogResult) -> Bool // 点击按钮结果

    // TextField 输入框即将输入文字。传回 TextShouldChange
    typealias DialogViewTextFieldShouldChange = (_ textField: UITextField, _ changeRange: NSRange, _ replacementText: String) -> TextShouldChange
    // TextField 输入框已经输入文字。传回 String 为nil或者为空字符串则清空提示
    typealias DialogViewTextFieldDidChange = (_ textField: UITextField) -> String?
    // TextView 输入框即将输入文字。传回 TextShouldChange
    typealias DialogViewTextViewShouldChange = (_ textView: UITextView, _ changeRange: NSRange, _ replacementText: String) -> TextShouldChange
    // TextView 输入框已经输入文字。传回 String 为nil或者为空字符串则清空提示
    typealias DialogViewTextViewDidChange = (_ textView: UITextView) -> String?

    var dialogResult: DialogViewResult?
    var dialogTextFieldShouldChange: DialogViewTextFieldShouldChange?
    var dialogTextFieldDidChange: DialogViewTextFieldDidChange?
    var dialogTextViewShouldChange: DialogViewTextViewShouldChange?
    var dialogTextViewDidChange: DialogViewTextViewDidChange?

    var showBlocks: [DialogViewShow] = []
    var removeFromQueueBlocks: [DialogViewRemoveFromQueue] = []
    var disappearBlocks: [DialogViewDisappear] = []
    var mainRemoveFromQueueBlock: DialogViewRemoveFromQueue?

    let dataModel = DialogViewModel()

    // 主内容视图
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        return contentView
    }()

    private lazy var result: DialogResult = {
        let result = DialogResult()
        result.dialogView = self
        return result
    }()

    // MARK: Configuration

    public func configDialogView(dialogModels: [Any], configuration: DialogViewConfig = DialogViewConfig()) {
        dataModel.dialogModels = dialogModels
        dataModel.configuration = configuration
        commonConfig()
    }

    public func configDialogViewByCustomHeight(customView: UIView,
                                               customViewHeight: CGFloat,
                                               configuration: DialogViewConfig = DialogViewConfig()) {
        dataModel.customView = customView
        dataModel.customViewWidth = DialogView.contentWidth()
        dataModel.customViewHeight = customViewHeight
        dataModel.configuration = configuration
        commonConfig()
    }

    public func configDialogViewByCustomSize(customView: UIView,
                                             customViewSize: CGSize,
                                             configuration: DialogViewConfig = DialogViewConfig()) {
        dataModel.customView = customView
        dataModel.customViewWidth = customViewSize.width
        dataModel.customViewHeight = customViewSize.height
        dataModel.configuration = configuration
        commonConfig()
    }

    static func contentWidth() -> CGFloat {
        let width: CGFloat = dialogScreenWidth < dialogScreenHeight ? dialogScreenWidth : dialogScreenHeight
        return width - DialogConfig.pattern().dialogLeftRightMargin * 2
    }

    static func keyView() -> UIView? {
        var keyView: UIView? = UIApplication.shared.keyWindow
        if keyView == nil {
            keyView = UIApplication.shared.windows.last
        }
        return keyView
    }

    private func commonConfig() {
        frame = CGRect(x: 0,
                       y: 0,
                       width: DialogView.dialogScreenWidth,
                       height: DialogView.dialogScreenHeight)
        if let unwrappedKeyView = DialogView.keyView() {
            unwrappedKeyView.addSubview(self)
            setUpDetailUI()
            createGestureRecognizer()
        }
    }

    // MARK: UI & Data

    private func setUpDetailUI() {
        dialogBecomeFirstResponder()

        // 内容宽度
        if let unwrappedCustomView = dataModel.customView {
            dataModel.contentViewWidth = dataModel.customViewWidth
            dataModel.contentViewHeight = dataModel.customViewHeight
            unwrappedCustomView.frame = CGRect(x: 0, y: 0, width: dataModel.contentViewWidth, height: dataModel.contentViewHeight)
            contentView.addSubview(unwrappedCustomView)
            contentView.backgroundColor = UIColor.clear
        } else {
            dataModel.contentViewWidth = DialogView.contentWidth()
            contentView.backgroundColor = UIColor.white
            contentView.layer.cornerRadius = DialogConfig.pattern().cornerRadius
            contentView.clipsToBounds = true

            var elementY: CGFloat = 0

            // 布局
            if let unwrappedDialogModels = dataModel.dialogModels {
                for object in unwrappedDialogModels {
                    if let model = object as? BasicDialogModel {
                        if model.elementClassName.isEmpty { continue }

                        if let aClass = DialogClassTool.getClass(classString: model.elementClassName) as? BasicDialogElement.Type {
                            let elementW: CGFloat = dataModel.contentViewWidth - model.margin.left - model.margin.right
                            let height: CGFloat = aClass.elementHeight(model: model, elementWidth: elementW)
                            let elementX = model.margin.left
                            elementY += model.margin.top
                            let elementH: CGFloat = ceil(height)

                            let element: BasicDialogElement = aClass.init()
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

    private func configSpecialElement(element: BasicDialogElement, model: BasicDialogModel) {
        if model.elementClassName == "ButtonsDialogElement" {
            if let unwrappedButtonsElement = element as? ButtonsDialogElement,
               let unwrappedButtonModel = model as? ButtonsDialogModel {
                dataModel.buttonsElement = unwrappedButtonsElement
                dataModel.buttonModel = unwrappedButtonModel

                unwrappedButtonsElement.clickBlock = { (_ buttonIndex: Int) in
                    self.clickOnButton(buttonIndex: buttonIndex)
                }
            }
        }

        if model.elementClassName == "TextFieldDialogElement" {
            if let unwrappedTextFieldElement = element as? TextFieldDialogElement {
                dataModel.textField = unwrappedTextFieldElement.textField
                dataModel.textField?.delegate = self
                dataModel.errorLabel = unwrappedTextFieldElement.errorLabel

                if dataModel.textField != nil {
                    addNotifications()
                }
            }
        }

        if model.elementClassName == "TextViewDialogElement" {
            if let unwrappedTextViewElement = element as? TextViewDialogElement {
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

        if model.elementClassName == "SelectorDialogElement" {
            if let unwrappedSelectorElement = element as? SelectorDialogElement {
                dataModel.selectorElement = unwrappedSelectorElement
                unwrappedSelectorElement.resultBlock = { (_ selectedItems: [SelectorDialogItem], _ selectedIndexes: [Int]) in
                    self.result.selectedItems = selectedItems
                    self.result.selectedIndexes = selectedIndexes

                    if let block = self.dialogResult {
                        let close = block(self.result)
                        if close {
                            self.closeDialogView()
                        }
                    }
                }
            }
        }
    }

    // MARK: Public Methods

    public func showDialogView() {
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

    public func closeDialogView() {
        closeDialogView(animation: true, stayInQueue: false)
    }

    public func closeDialogView(stayInQueue: Bool) {
        closeDialogView(animation: false, stayInQueue: stayInQueue)
    }

    public func removeDialogViewFromQueue() {
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

    public func closeDialogView(animation: Bool, stayInQueue: Bool) {
        if dataModel.configuration.animation == .showNone || !animation {
            backgroundColor = dataModel.backStartColor
            contentView.frame = dataModel.startRect
            if dataModel.configuration.animation == .showFade {
                contentView.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = self.dataModel.backStartColor
                self.contentView.frame = self.dataModel.startRect
                if self.dataModel.configuration.animation == .showFade {
                    self.contentView.alpha = 0.0
                }
            } completion: { _ in
                self.finishedCloseDialogView(stayInQueue: stayInQueue)
            }
        }
    }

    public func finishedCloseDialogView(stayInQueue: Bool) {
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

    public func dialogBecomeFirstResponder() {
        if let unwrappedTextField = dataModel.textField {
            unwrappedTextField.becomeFirstResponder()
        }

        if let unwrappedTextView = dataModel.textView {
            unwrappedTextView.becomeFirstResponder()
        }
    }

    public func dialogResignFirstResponder() {
        if let unwrappedTextField = dataModel.textField {
            unwrappedTextField.resignFirstResponder()
        }

        if let unwrappedTextView = dataModel.textView {
            unwrappedTextView.resignFirstResponder()
        }
    }

    public func sideTapEnable(enable: Bool) {
        dataModel.configuration.sideTap = enable
    }

    public func enableButton(buttonIndex: Int) {
        dataModel.buttonsElement?.enableButton(buttonIndex: buttonIndex)
    }

    public func disableButton(buttonIndex: Int) {
        dataModel.buttonsElement?.disableButton(buttonIndex: buttonIndex)
    }

    public func addShowBlock(showBlock: @escaping DialogViewShow) {
        showBlocks.append(showBlock)
    }

    public func addDisappearBlock(disappearBlock: @escaping DialogViewDisappear) {
        disappearBlocks.append(disappearBlock)
    }

    public func addRemoveFromQueueBlock(removeFromQueueBlock: @escaping DialogViewRemoveFromQueue) {
        removeFromQueueBlocks.append(removeFromQueueBlock)
    }

    public func setUpMainRemoveFromQueueBlock(mainRemoveFromQueueBlock: @escaping DialogViewRemoveFromQueue) {
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
                result.buttonTitle = model.buttonTitles[buttonIndex]
            } else {
                result.buttonTitle = "SideTap"
            }

            if let block = dialogResult {
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
                    closeDialogView()
                }

            } else {
                closeDialogView()
            }
        } else {
            closeDialogView()
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

        if dataModel.finalRect.maxY > DialogView.dialogScreenHeight - keyBoardHeight {
            UIView.animate(withDuration: duration ?? 0.2) {
                var newRect = self.dataModel.finalRect
                newRect.origin.y = floor(DialogView.dialogScreenHeight - keyBoardHeight - self.dataModel.finalRect.height) - 24.0
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
        if let block = dialogTextFieldDidChange, let unwrappedTextField = dataModel.textField {
            let errorString = block(unwrappedTextField)
            showErrorTips(errorTips: errorString ?? "")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: UITextFieldDelegate

    func textFieldDidEndEditing(_ textField: UITextField) {
        result.inputText = textField.text ?? ""
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let block = dialogTextFieldShouldChange, let unwrappedTextField = dataModel.textField {
            let model = block(unwrappedTextField, range, string)
            showErrorTips(errorTips: model.tip ?? "")
            return model.shouldChange
        } else {
            return true
        }
    }

    // MARK: UITextViewDelegate

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
        if let block = dialogTextViewDidChange, let unwrappedTextView = dataModel.textView {
            let errorString = block(unwrappedTextView)
            showErrorTips(errorTips: errorString ?? "")
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let block = dialogTextViewShouldChange, let unwrappedTextView = dataModel.textView {
            let model = block(unwrappedTextView, range, text)
            showErrorTips(errorTips: model.tip ?? "")
            return model.shouldChange
        } else {
            return true
        }
    }

    // MARK: UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self
    }
}
