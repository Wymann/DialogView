//
//  DialogDemoViewController.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class DialogDemoViewController: UIViewController {
    private lazy var sections: [DialogDemoSection] = DialogDemoModel.createDemoData()
    private let cellReuseIdentifier = "DialogDemoViewCell"
    private let headerReuseIdentifier = "DialogDemoViewHeaderCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Dialog Demo"

        addViewContents()
    }
}

extension DialogDemoViewController {
    private func addViewContents() {
        tableView.frame = self.view.bounds
        view.addSubview(tableView)
    }
}

extension DialogDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].dialogModels.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].dialogModels[indexPath.row].cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        let unwrappedCell = cell ?? UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        let model = sections[indexPath.section].dialogModels[indexPath.row]
        unwrappedCell.selectionStyle = .none
        unwrappedCell.textLabel?.font = DialogConfig.normalFont(ofSize: 15.0)
        unwrappedCell.textLabel?.text = model.title
        unwrappedCell.detailTextLabel?.font = DialogConfig.normalFont(ofSize: 12.0)
        unwrappedCell.detailTextLabel?.numberOfLines = 0
        unwrappedCell.detailTextLabel?.lineBreakMode = .byWordWrapping
        unwrappedCell.detailTextLabel?.text = model.subTitle
        return unwrappedCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier)
        let unwrappedHeader = header ?? UITableViewHeaderFooterView(reuseIdentifier: headerReuseIdentifier)
        unwrappedHeader.textLabel?.text = sections[section].title
        unwrappedHeader.textLabel?.font = DialogConfig.boldFont(ofSize: 15.0)
        return unwrappedHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = sections[indexPath.section].dialogModels[indexPath.row]

        switch model.type {
        case .common: showCommonDialog(model: model)
        case .specialColors: showSpecialColorsDialog(model: model)
        case .image: showImageDialog(model: model)
        case .customView: showCustomViewDialog(model: model)
        case .input: showInputDialog(model: model)
        case .sheet: showSheetDialog(model: model)
        }
    }
}

extension DialogDemoViewController {
    private func showCommonDialog(model: DialogDemoModel) {
        let buttons = ["取消", "确定"]

        switch model.subType {
        case .commonEnableSideTap:
            Dialog.elk.showDialog(title: model.title,
                                  subtitle: model.subTitle,
                                  buttons: buttons) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                return true
            }
        case .commonDisableSideTap:
            let view = Dialog.elk.showDialog(title: model.title,
                                             subtitle: model.subTitle,
                                             buttons: buttons) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                return true
            }
            view.sideTapEnable(enable: false)
        case .commonVerticalButtons:
            let buttons1 = ["确定", "取消"]
            let lontSubtitle = "。这里测试一个长的副标题：这是一个很长，很长很长很长很长很长很长很长很长的副标题，超过一行的副标题。"
            Dialog.elk.showDialog(title: model.title,
                                  subtitle: model.subTitle + lontSubtitle,
                                  buttons: buttons1,
                                  buttonsLayoutType: .vertical) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                return true
            }
        default: return
        }
    }

    private func showSpecialColorsDialog(model: DialogDemoModel) {
        switch model.subType {
        case .specialColorsCommon:
            let specialButtons = ["优秀", "良好", "及格"]
            let specialColor = DialogSpecialColor(subtitleColor: "#8B008B",
                                                  buttonColors: ["#4169E1", "#1E90FF", "#00CED1"])
            Dialog.elk.showDialog(title: model.title,
                                  subtitle: model.subTitle,
                                  buttons: specialButtons,
                                  specialColor: specialColor) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                return true
            }
        case .specialColorsAttributed:
            let specialButtons = ["已读", "未读", "下次"]
            let specialColor = DialogSpecialColor(titleColor: "#8B008B",
                                                  buttonColors: ["#4169E1", "#1E90FF", "#00CED1"])
            let subtitle = "When you are old\n-- William Butler Yeats\nWhen you are old and grey and full of sleep,\nAnd nodding by the fire，take down this book,\nAnd slowly read,and dream of the soft look"
            let attributedString = NSMutableAttributedString(string: subtitle)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3.0
            paragraphStyle.alignment = .left

            let paragraphStyle2 = NSMutableParagraphStyle()
            paragraphStyle2.lineSpacing = 5.0
            paragraphStyle2.alignment = .right

            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: subtitle.count))
            attributedString.addAttribute(NSAttributedString.Key.font, value: DialogConfig.normalFont(ofSize: 14.0), range: NSRange(location: 0, length: subtitle.count))
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle2, range: subtitle.elk.range(of: "-- William Butler Yeats"))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: subtitle.elk.range(of: "When you are old"))

            Dialog.elk.showDialog(title: model.title,
                                  attributedSubtitle: attributedString,
                                  buttons: specialButtons,
                                  specialColor: specialColor) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                return true
            }

        default: return
        }
    }

    private func showImageDialog(model: DialogDemoModel) {
        switch model.subType {
        case .localImage:
            let buttons = ["知道了"]
            let subtitle = "需要打开系统蓝牙设置，具体参照弹框中的图片。"
            let localImage = DialogLocalImage(image: UIImage(named: "DialogDemoImage1") ?? UIImage(), configuration: imageConfiguration())
            Dialog.elk.showDialog(title: model.title,
                                  subtitle: subtitle,
                                  localImage: localImage,
                                  buttons: buttons) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                return true
            }
        case .netImage:
            let buttons = ["取消", "查看", "报警"]
            let subtitle = "智能门铃检测到有人在门口徘徊，是否需要前往查看？"
            let imageUrl = "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=623994087,1173615898&fm=26&gp=0.jpg"
            let imageSize = CGSize(width: 600, height: 600)
            let placeHolder = UIImage(named: "PlaceholderImage")
            let errorImage = UIImage(named: "ErrorImage")
            let netImage = DialogNetImage(imageUrl: imageUrl,
                                          placeholder: placeHolder,
                                          errorImage: errorImage,
                                          imageSize: imageSize,
                                          configuration: imageConfiguration())
            Dialog.elk.showDialog(title: model.title,
                                  subtitle: subtitle,
                                  netImage: netImage,
                                  buttons: buttons) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                return true
            }
        default: return
        }
    }

    private func showCustomViewDialog(model: DialogDemoModel) {
        switch model.subType {
        case .customViewOnlyHeight:
            let customView = UILabel()
            customView.backgroundColor = UIColor.blue
            customView.text = "这是一个自定义视图（固定高度，宽度按照弹框标准: DialogPattern）。\n点击空白处消失"
            customView.numberOfLines = 0
            customView.font = DialogConfig.boldFont(ofSize: 15.0)
            customView.textColor = UIColor.white
            customView.textAlignment = .center

            let view = Dialog.elk.showDialog(customView: customView,
                                             customViewHeight: 200,
                                             resultBlock: nil)
            view.sideTapEnable(enable: true)
        case .customViewOnlySize:
            let customView = UILabel()
            customView.backgroundColor = UIColor.red
            customView.text = "这是一个自定义视图（固定 Size）。\n2秒后调用关闭弹框方法消失。"
            customView.numberOfLines = 0
            customView.font = DialogConfig.boldFont(ofSize: 15.0)
            customView.textColor = UIColor.white
            customView.textAlignment = .center

            let size = CGSize(width: 250, height: 460)

            let view = Dialog.elk.showDialog(customView: customView,
                                             customViewSize: size,
                                             resultBlock: nil)
            view.sideTapEnable(enable: false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                view.closeDialogView()
            }
        case .customViewHeightAndPosition:
            let customView = UILabel()
            customView.backgroundColor = UIColor.blue
            customView.text = "这是一个自定义视图（固定高度，宽度按照弹框标准: DialogPattern）。\n点击空白处消失\n自定义了弹出的动画以及弹框最后停留位置"
            customView.numberOfLines = 0
            customView.font = DialogConfig.boldFont(ofSize: 15.0)
            customView.textColor = UIColor.white
            customView.textAlignment = .center

            let configuration = DialogViewConfig(animation: .showFromBottom,
                                                 position: .stayBottom,
                                                 bounce: true)

            let view = Dialog.elk.showDialog(customView: customView,
                                             customViewHeight: 200,
                                             configuration: configuration,
                                             resultBlock: nil)
            view.sideTapEnable(enable: true)
        case .customViewSizeAndPosition:
            let customView = UILabel()
            customView.backgroundColor = UIColor.red
            customView.text = "这是一个自定义视图（固定 Size）。\n2秒后调用关闭弹框方法消失。\n自定义了弹出的动画以及弹框最后停留位置"
            customView.numberOfLines = 0
            customView.font = DialogConfig.boldFont(ofSize: 15.0)
            customView.textColor = UIColor.white
            customView.textAlignment = .center

            let size = CGSize(width: view.frame.width, height: 200)

            let configuration = DialogViewConfig(animation: .showFromTop,
                                                 position: .stayTop,
                                                 bounce: true)

            let view = Dialog.elk.showDialog(customView: customView,
                                             customViewSize: size,
                                             configuration: configuration,
                                             resultBlock: nil)
            view.sideTapEnable(enable: false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                view.closeDialogView()
            }

        default: return
        }
    }

    private func showInputDialog(model: DialogDemoModel) {
        let buttons = ["取消", "确定"]
        switch model.subType {
        case .inputTextField:
            let input = DialogTextFieldInput(placeHolder: "输入名称")
            let view = Dialog.elk.showDialog(title: model.title,
                                             subtitle: model.subTitle + "。不能包含“我”这个字",
                                             textFieldInput: input,
                                             buttons: buttons) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                if result.buttonIndex == 1 {
                    print("输入框结果 \(result.inputText)")
                }
                return true
            }
            view.dialogTextFieldShouldChange = { (_ textField: UITextField, _ changeRange: NSRange, _ replacementText: String) -> TextShouldChange in
                if replacementText.range(of: "我") != nil {
                    return TextShouldChange(shouldChange: false, tip: "输入不能包含“我”这个字")
                } else {
                    return TextShouldChange(shouldChange: true)
                }
            }
            view.sideTapEnable(enable: false)
        case .inputTextFieldLimit:
            let input = DialogTextFieldInput(placeHolder: "输入密码",
                                             keyboardType: .numberPad,
                                             secureTextEntry: true,
                                             clearButtonMode: .always)
            let view = Dialog.elk.showDialog(title: model.title,
                                             subtitle: model.subTitle + "。不能输入超过10个字符，且必须输入才能确定。",
                                             textFieldInput: input,
                                             buttons: buttons) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                if result.buttonIndex == 1 {
                    print("输入框结果 \(result.inputText)")
                }
                return true
            }

            // 初始时候让“确定”按钮无法点击
            view.disableButton(buttonIndex: 1)

            view.dialogTextFieldDidChange = { (_ textField: UITextField) -> String? in
                if let text = textField.text, !text.isEmpty {
                    view.enableButton(buttonIndex: 1)
                } else {
                    view.disableButton(buttonIndex: 1)
                }

                let maxLength = 10

                let toBeString: NSString = .init(string: textField.text ?? "")
                var position: UITextPosition?
                if let selectedRange = textField.markedTextRange {
                    position = textField.position(from: selectedRange.start, offset: 0)
                }

                if position == nil, toBeString.length > maxLength {
                    let rangeIndex1 = toBeString.rangeOfComposedCharacterSequence(at: maxLength)
                    if rangeIndex1.length == 1 {
                        textField.text = toBeString.substring(to: 10)
                    } else {
                        let rangeIndex2 = toBeString.rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: maxLength))
                        textField.text = toBeString.substring(with: rangeIndex2)
                    }
                    return "输入字符不能超过10个"
                } else {
                    return nil
                }
            }
            view.sideTapEnable(enable: false)
        case .inputTextView:
            let input = DialogTextViewInput(placeHolder: "输入反馈", maxTextLength: 210)
            let view = Dialog.elk.showDialog(title: model.title,
                                             subtitle: model.subTitle,
                                             textViewInput: input,
                                             buttons: buttons) { result in
                print("点击了 \(result.buttonIndex): \(result.buttonTitle)")
                if result.buttonIndex == 1 {
                    print("输入框结果 \(result.inputText)")
                }
                return true
            }

            view.dialogTextViewShouldChange = { (_ textView: UITextView, _ changeRange: NSRange, _ replacementText: String) -> TextShouldChange in
                print("TextViewShouldChange: \(textView.text + replacementText)")
                return TextShouldChange(shouldChange: true)
            }

            view.dialogTextViewDidChange = { (_ textView: UITextView) -> String? in
                print("TextViewDidChange: \(String(describing: textView.text))")
                return nil
            }

            view.sideTapEnable(enable: false)
        default: return
        }
    }

    private func showSheetDialog(model: DialogDemoModel) {
        let buttons = ["取消", "确定"]
        switch model.subType {
        case .sheetNoneSelect:
            let config = SheetConfiguration(dialogTitle: model.title,
                                            dialogSubtitle: model.subTitle,
                                            maxSelectNumber: 0,
                                            buttons: ["取消"])
            Dialog.elk.showSheet(models: DialogDemoModel.sheetModels(true),
                                 configuration: config,
                                 itemClickBlock: { _, itemIndex in
                                     print("点击了选项: \(itemIndex)")
                                     return true
                                 })
        case .sheetSingleSelect1:
            let config = SheetConfiguration(dialogTitle: model.title,
                                            dialogSubtitle: model.subTitle,
                                            maxSelectNumber: 1,
                                            buttons: ["取消"])
            Dialog.elk.showSheet(models: DialogDemoModel.sheetModels(false, selectedIndexes: [1], number: 5),
                                 configuration: config,
                                 itemClickBlock: { _, itemIndex in
                                     print("点击了选项: \(itemIndex)")
                                     return true
                                 })
        case .sheetSingleSelect2:
            let config = SheetConfiguration(dialogTitle: model.title,
                                            dialogSubtitle: model.subTitle,
                                            maxSelectNumber: 1,
                                            buttons: ["取消", "确定"])
            Dialog.elk.showSheet(models: DialogDemoModel.sheetModels(true, selectedIndexes: [1]),
                                 configuration: config,
                                 buttonClickBlock: { result, buttonIndex in
                                     print("点击了按钮: \(buttonIndex), 当前选择项：\(result.selectedIndexes)")
                                     return true
                                 })
        case .sheetMultipleSelect:
            let config = SheetConfiguration(dialogTitle: model.title,
                                            dialogSubtitle: model.subTitle,
                                            maxSelectNumber: 3,
                                            buttons: ["取消", "确定"])
            Dialog.elk.showSheet(models: DialogDemoModel.sheetModels(false, number: 6),
                                 configuration: config,
                                 buttonClickBlock: { result, buttonIndex in
                                     print("点击了按钮: \(buttonIndex), 当前选择项：\(result.selectedIndexes)")
                                     return true
                                 })
        default: return
        }
    }

    func imageConfiguration() -> DialogImageConfiguration {
        return DialogImageConfiguration(sizeType: .common, position: .middle)
    }
}
