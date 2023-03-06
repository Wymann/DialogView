//
//  BubbleSheetCell.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/31.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

class BubbleSheetCell: UITableViewCell {
    static let sheetCellTopGap: CGFloat = 16.0
    static let sheetCellTitleHeight: CGFloat = 24.0
    static let sheetCellSubtitleHeight: CGFloat = 20.0
    static let sheetCellBottomGap: CGFloat = 16.0
    static let sheetCellVGap: CGFloat = 5.0

    private lazy var cellTitleLabel: UILabel = {
        let cellTitleLabel = UILabel()
        cellTitleLabel.textColor = UIColor(hexString: "#2D3132")
        cellTitleLabel.textAlignment = .center
        cellTitleLabel.font = BubbleConfig.normalFont(ofSize: 16.0)
        return cellTitleLabel
    }()

    private lazy var cellSubtitleLabel: UILabel = {
        let cellSubtitleLabel = UILabel()
        cellSubtitleLabel.textColor = UIColor(hexString: "#2D3132" + "99")
        cellSubtitleLabel.textAlignment = .center
        cellSubtitleLabel.font = BubbleConfig.normalFont(ofSize: 14.0)
        return cellSubtitleLabel
    }()

    private lazy var checkButton: UIButton = {
        let checkButton = UIButton(type: .custom)
        checkButton.setBackgroundImage(UIImage(named: "SheetSingleUncheck"), for: .normal)
        checkButton.setBackgroundImage(UIImage(named: "SheetSingleCheck"), for: .selected)
        return checkButton
    }()

    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#E6E6E6")
        return line
    }()

    private var model: SheetModel = .empty
    private var needCheck: Bool = false
    private var showLine: Bool = true
    private var multiple: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViewContents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configData(model: SheetModel,
                    needCheck: Bool,
                    showLine: Bool,
                    multiple: Bool) {
        self.model = model
        self.needCheck = needCheck
        self.showLine = showLine
        self.multiple = multiple

        addViewConstraints()
        updateViewContents()
    }
}

extension BubbleSheetCell {
    private func addViewContents() {
        contentView.addSubview(cellTitleLabel)
        contentView.addSubview(cellSubtitleLabel)
        contentView.addSubview(checkButton)
        contentView.addSubview(line)
    }

    private func addViewConstraints() {
        checkButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-18.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 25.0, height: 25.0))
        }

        let titleLeadingGap = !multiple && needCheck ? 54.0 : 18.0
        let titleTrailingGap = needCheck ? -54.0 : -18.0

        cellTitleLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(titleTrailingGap)
            make.leading.equalToSuperview().offset(titleLeadingGap)
            make.top.equalToSuperview().offset(BubbleSheetCell.sheetCellTopGap)
            make.height.equalTo(BubbleSheetCell.sheetCellTitleHeight)
        }

        cellSubtitleLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(titleTrailingGap)
            make.leading.equalToSuperview().offset(titleLeadingGap)
            make.top.equalTo(self.cellTitleLabel.snp.bottom).offset(BubbleSheetCell.sheetCellVGap)
            make.height.equalTo(BubbleSheetCell.sheetCellSubtitleHeight)
        }

        line.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(18.0)
            make.trailing.equalToSuperview().offset(-18.0)
            make.height.equalTo(0.33)
            make.bottom.equalToSuperview()
        }

        cellTitleLabel.textAlignment = multiple ? .left : .center
        cellSubtitleLabel.textAlignment = multiple ? .left : .center

        let normalImage = multiple ? "SheetMultipleUncheck" : "SheetSingleUncheck"
        let selectedImage = multiple ? "SheetMultipleCheck" : "SheetSingleCheck"

        checkButton.setBackgroundImage(UIImage(named: normalImage), for: .normal)
        checkButton.setBackgroundImage(UIImage(named: selectedImage), for: .selected)
    }

    private func updateViewContents() {
        cellTitleLabel.text = model.title
        cellSubtitleLabel.text = model.subtitle
        cellSubtitleLabel.isHidden = model.subtitle.isEmpty
        checkButton.isHidden = !needCheck
        checkButton.isSelected = model.selected
        line.isHidden = !showLine
        contentView.bringSubviewToFront(line)
    }
}

extension BubbleSheetCell {
    static func sheetCellHeight(model: SheetModel, cellWidth: CGFloat) -> CGFloat {
        var cellHeight = sheetCellTopGap + sheetCellBottomGap

        cellHeight += sheetCellTitleHeight

        if !model.subtitle.isEmpty {
            cellHeight += sheetCellSubtitleHeight
        }

        if !model.title.isEmpty, !model.subtitle.isEmpty {
            cellHeight += sheetCellVGap
        }
        return cellHeight
    }
}
