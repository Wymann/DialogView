//
//  DialogSheet.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/31.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class DialogSheet: UIView {
    static let sheetTitleTopGap: CGFloat = 10.0 // Sheet 标题顶部距离
    static let sheetTitleBottomGap: CGFloat = 10.0 // Sheet 标题底部距离
    static let sheetTitleBetweenGap: CGFloat = 10.0 // Sheet 标题与副标题距离

    static let sheetHeaderHeight: CGFloat = 10.0 // TableView header 高度
    static let sheetFooterHeight: CGFloat = 10.0 // TableView footer 高度
    static let sheetGapLine: CGFloat = 8.0 // 底部横隔线的高度
    static let sheetButtonHeight: CGFloat = 56.0 // 按钮高度

    static let sheetTitleLeftRightGap: CGFloat = 10.0 // Sheet 标题左右距离
    static let sheetTitleFontSize: CGFloat = 18.0 // Sheet 标题字体大小
    static let sheetSubtitleFontSize: CGFloat = 16.0 // Sheet 副标题字体大小

    private let sheetButtonFontSize: CGFloat = 18.0 // Sheet 按钮字体大小
    private let cellReuseIdentifier: String = "DialogSheetCell"

    // 点击 Sheet 选项回调，Bool 表示是否关闭 Sheet
    typealias DialogSheetItemClick = (_ result: SheetResult, _ itemIndex: Int) -> Bool

    // 点击底部按钮回调，Bool 表示是否关闭 Sheet
    typealias DialogSheetButtonClick = (_ result: SheetResult, _ buttonIndex: Int) -> Bool

    var models: [SheetModel]
    var configuration: SheetConfiguration
    var itemClickBlock: DialogSheetItemClick?
    var buttonClickBlock: DialogSheetButtonClick?

    var result: SheetResult = .init()
    var dialogView: DialogView?

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = DialogConfig.boldFont(ofSize: DialogSheet.sheetTitleFontSize)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hexString: DialogConfig.commonColor()) ?? UIColor.black
        return titleLabel
    }()

    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = DialogConfig.normalFont(ofSize: DialogSheet.sheetSubtitleFontSize)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(hexString: DialogConfig.commonColor()) ?? UIColor.darkGray
        return subtitleLabel
    }()

    private lazy var topGapLine: UIView = {
        let topGapLine = UIView()
        topGapLine.backgroundColor = UIColor(hexString: "#F4F4F4")
        return topGapLine
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = DialogSheet.sheetHeaderHeight
        tableView.sectionFooterHeight = DialogSheet.sheetFooterHeight
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.register(DialogSheetCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()

    private lazy var bottomGapLine: UIView = {
        let bottomGapLine = UIView()
        bottomGapLine.backgroundColor = UIColor(hexString: "#F4F4F4")
        return bottomGapLine
    }()

    init(frame: CGRect,
         models: [SheetModel],
         configuration: SheetConfiguration = SheetConfiguration(),
         itemClickBlock: DialogSheetItemClick? = nil,
         buttonClickBlock: DialogSheetButtonClick? = nil) {
        self.models = models
        self.configuration = configuration
        self.itemClickBlock = itemClickBlock
        self.buttonClickBlock = buttonClickBlock
        super.init(frame: frame)

        setUpDetailUI()
        updateResult()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DialogSheet {
    private func setUpDetailUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 12.0
        clipsToBounds = true

        if !configuration.dialogTitle.isEmpty {
            let titleX = DialogSheet.sheetTitleLeftRightGap
            let titleY = DialogSheet.sheetTitleTopGap
            let titleW = bounds.width - DialogSheet.sheetTitleLeftRightGap * 2
            let titleH = UILabel.elk.labelHeight(text: configuration.dialogTitle,
                                                 width: titleW,
                                                 font: titleLabel.font)
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            titleLabel.text = configuration.dialogTitle
            addSubview(titleLabel)
        }

        if !configuration.dialogSubtitle.isEmpty {
            let subtitleX = DialogSheet.sheetTitleLeftRightGap
            let subtitleY = !configuration.dialogTitle.isEmpty ? titleLabel.frame.maxY + DialogSheet.sheetTitleBetweenGap : DialogSheet.sheetTitleTopGap
            let subtitleW = bounds.width - DialogSheet.sheetTitleLeftRightGap * 2
            let subtitleH = UILabel.elk.labelHeight(text: configuration.dialogSubtitle,
                                                    width: subtitleW,
                                                    font: subtitleLabel.font)
            subtitleLabel.frame = CGRect(x: subtitleX, y: subtitleY, width: subtitleW, height: subtitleH)
            subtitleLabel.text = configuration.dialogSubtitle
            addSubview(subtitleLabel)
        }

        var tableViewY = 0.0

        if !configuration.dialogTitle.isEmpty || !configuration.dialogSubtitle.isEmpty {
            let topGapLineX = 0.0
            let topGapLineY = !configuration.dialogSubtitle.isEmpty ? subtitleLabel.frame.maxY + DialogSheet.sheetGapLine : titleLabel.frame.maxY + DialogSheet.sheetGapLine
            let topGapLineW = frame.width
            let topGapLineH = DialogSheet.sheetGapLine
            topGapLine.frame = CGRect(x: topGapLineX, y: topGapLineY, width: topGapLineW, height: topGapLineH)
            addSubview(topGapLine)

            tableViewY = topGapLine.frame.maxY
        }

        let tableViewH: CGFloat = DialogSheet.dialogTableViewHeight(models: models,
                                                                    configuration: configuration,
                                                                    sheetWidth: frame.width)

        tableView.frame = CGRect(x: 0, y: tableViewY, width: frame.width, height: tableViewH)
        addSubview(tableView)

        if !configuration.buttons.isEmpty {
            let bottomGapLineX = 0.0
            let bottomGapLineY = tableView.frame.maxY
            let bottomGapLineW = frame.width
            let bottomGapLineH = DialogSheet.sheetGapLine
            bottomGapLine.frame = CGRect(x: bottomGapLineX, y: bottomGapLineY, width: bottomGapLineW, height: bottomGapLineH)
            addSubview(bottomGapLine)

            let buttonWidth = CGFloat(frame.width) / CGFloat(configuration.buttons.count)
            for (index, buttonTitle) in configuration.buttons.enumerated() {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: bottomGapLine.frame.maxY, width: buttonWidth, height: DialogSheet.sheetButtonHeight)
                button.titleLabel?.font = DialogConfig.normalFont(ofSize: sheetButtonFontSize)
                button.setTitle(buttonTitle, for: .normal)
                button.setTitleColor(UIColor(hexString: DialogConfig.commonColor()), for: .normal)
                button.setTitleColor(UIColor(hexString: DialogConfig.commonColor() + "80"), for: .highlighted)
                button.tag = 999 + index
                addSubview(button)

                if index != configuration.buttons.count - 1 {
                    let lineView = UIView()
                    lineView.backgroundColor = UIColor(hexString: "E6E6E6")
                    lineView.frame = CGRect(x: button.frame.maxX - 0.5, y: button.frame.minY, width: 0.5, height: button.frame.height)
                    addSubview(lineView)
                }

                button.addTarget(self, action: #selector(clickBottomButton(_:)), for: .touchUpInside)
            }
        }

        tableView.isScrollEnabled = models.count > configuration.maxShowNumber
    }
}

@objc
extension DialogSheet {
    private func clickBottomButton(_ button: UIButton) {
        let index = button.tag - 999
        if let block = buttonClickBlock {
            let close = block(result, index)
            if close { dialogView?.closeDialogView() }
        } else {
            dialogView?.closeDialogView()
        }
    }
}

extension DialogSheet {
    private func updateResult() {
        result.selectedIndexes.removeAll()
        result.selectedModels.removeAll()

        for (index, model) in models.enumerated() where model.selected {
            result.selectedIndexes.append(index)
            result.selectedModels.append(model)
        }
    }
}

extension DialogSheet: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = models[indexPath.row]
        return DialogSheetCell.sheetCellHeight(model: model, cellWidth: frame.width)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? DialogSheetCell
        let unwrappedCell = cell ?? DialogSheetCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        let model = models[indexPath.row]
        unwrappedCell.configData(model: model,
                                 needCheck: configuration.maxSelectNumber > 0,
                                 showLine: indexPath.row != models.count - 1,
                                 multiple: configuration.maxSelectNumber > 1)
        unwrappedCell.selectionStyle = configuration.maxSelectNumber > 0 ? .none : .default

        return unwrappedCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat = !models.isEmpty ? DialogSheet.sheetHeaderHeight : 0.0
        return headerHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerHeight: CGFloat = !models.isEmpty ? DialogSheet.sheetFooterHeight : 0.0
        return footerHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let currentSelectModel = models[indexPath.row]

        if configuration.maxSelectNumber > 1 {
            var reloadRows: [IndexPath] = []
            if result.selectedIndexes.contains(indexPath.row) {
                currentSelectModel.selected = false
                reloadRows.append(indexPath)
            } else if result.selectedIndexes.count < configuration.maxSelectNumber {
                currentSelectModel.selected = true
                reloadRows.append(indexPath)
            }
            self.tableView.reloadRows(at: reloadRows, with: .none)
        } else if configuration.maxSelectNumber == 1 {
            var reloadRows: [IndexPath] = []
            if let oldSelectedModel = result.selectedModels.first {
                oldSelectedModel.selected = false
                if let oldSelectedIndex = result.selectedIndexes.first {
                    reloadRows.append(IndexPath(row: oldSelectedIndex, section: 0))
                }
            }
            currentSelectModel.selected = true
            reloadRows.append(indexPath)
            self.tableView.reloadRows(at: reloadRows, with: .none)
        }

        updateResult()

        if let block = itemClickBlock, currentSelectModel.selected || configuration.maxSelectNumber == 0 {
            let close = block(result, indexPath.row)
            if close { dialogView?.closeDialogView() }
        }
    }
}

extension DialogSheet {
    static func sheetWidth() -> CGFloat {
        let width: CGFloat = DialogView.dialogScreenWidth < DialogView.dialogScreenHeight ? DialogView.dialogScreenWidth : DialogView.dialogScreenHeight
        return width - 16.0
    }

    static func dialogSheetHeight(models: [SheetModel],
                                  configuration: SheetConfiguration = SheetConfiguration(),
                                  sheetWidth: CGFloat) -> CGFloat {
        var sheetHeight: CGFloat = 0.0
        if !configuration.dialogTitle.isEmpty || !configuration.dialogSubtitle.isEmpty {
            sheetHeight += sheetTitleTopGap

            if !configuration.dialogTitle.isEmpty {
                let titleW = sheetWidth - sheetTitleLeftRightGap * 2
                let titleH = UILabel.elk.labelHeight(text: configuration.dialogTitle,
                                                     width: titleW,
                                                     font: DialogConfig.boldFont(ofSize: sheetTitleFontSize))
                sheetHeight += titleH
            }

            if !configuration.dialogSubtitle.isEmpty {
                let subtitleW = sheetWidth - sheetTitleLeftRightGap * 2
                let subtitleH = UILabel.elk.labelHeight(text: configuration.dialogSubtitle,
                                                        width: subtitleW,
                                                        font: DialogConfig.normalFont(ofSize: DialogSheet.sheetSubtitleFontSize))
                sheetHeight += subtitleH
            }

            if !configuration.dialogTitle.isEmpty, !configuration.dialogSubtitle.isEmpty {
                sheetHeight += sheetTitleBetweenGap
            }

            sheetHeight += (sheetTitleBottomGap + sheetGapLine)
        }

        let tableViewHeight: CGFloat = DialogSheet.dialogTableViewHeight(models: models,
                                                                         configuration: configuration,
                                                                         sheetWidth: sheetWidth)

        sheetHeight += tableViewHeight

        if !configuration.buttons.isEmpty {
            sheetHeight += (sheetGapLine + sheetButtonHeight)
        }

        return sheetHeight
    }

    private static func dialogTableViewHeight(models: [SheetModel],
                                              configuration: SheetConfiguration = SheetConfiguration(),
                                              sheetWidth: CGFloat) -> CGFloat {
        var tableViewHeight: CGFloat = !models.isEmpty ? sheetHeaderHeight + sheetFooterHeight : 0.0

        for (index, sheetModel) in models.enumerated() {
            if index < configuration.maxShowNumber {
                tableViewHeight += DialogSheetCell.sheetCellHeight(model: sheetModel, cellWidth: sheetWidth)
            } else {
                tableViewHeight -= sheetFooterHeight
                break
            }
        }

        return tableViewHeight
    }
}
