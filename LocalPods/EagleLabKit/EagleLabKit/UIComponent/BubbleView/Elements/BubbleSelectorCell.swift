//
//  BubbleSelectorCell.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/22.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class BubbleSelectorCell: UITableViewCell {
    let leftGap: CGFloat = 24.0
    let rightGap: CGFloat = 24.0
    let topGap: CGFloat = 10.0
    let bottomGap: CGFloat = 10.0
    let arrowImageWidth: CGFloat = 14.0
    let dotImageWidth: CGFloat = 22.0
    let hGap: CGFloat = 16.0

    var item: SelectorBubbleItem = .init()

    private lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = BubbleConfig.normalFont(ofSize: 16.0)
        return titleLab
    }()

    private lazy var subtitleLab: UILabel = {
        let subtitleLab = UILabel()
        subtitleLab.textAlignment = NSTextAlignment.right
        titleLab.font = BubbleConfig.normalFont(ofSize: 14.0)
        return subtitleLab
    }()

    private lazy var arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "SelectorBubbleArrow")
        return arrowView
    }()

    private lazy var selectView: UIImageView = {
        let selectView = UIImageView()
        selectView.image = UIImage(named: "SelectorBubbleDot0")
        selectView.highlightedImage = UIImage(named: "SelectorBubbleDot1")
        return selectView
    }()

    private lazy var underline: UIView = {
        let underline = UIView()
        return underline
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpDetailSelectorCell(selectorItem: item)
    }

    private func setUpDetailSelectorCell(selectorItem: SelectorBubbleItem) {
        var imageWidth: CGFloat = 0.0

        if selectorItem.preference.maxSelectNum == 1, selectorItem.preference.resultFromItemTap {
            imageWidth = arrowImageWidth
        } else {
            imageWidth = dotImageWidth
        }

        setUpTitleLabel(preference: selectorItem.preference, selectorItem: selectorItem, imageWidth: imageWidth)

        setUpImageView(preference: selectorItem.preference, selectorItem: selectorItem, imageWidth: imageWidth)

        setUpUnderline()
    }

    private func setUpTitleLabel(preference: SelectorPreference, selectorItem: SelectorBubbleItem, imageWidth: CGFloat) {
        var titleLabWidth: CGFloat = 0.0
        var subtitleLabWidth: CGFloat = 0.0

        if !selectorItem.subtitle.isEmpty {
            let totalTitleWidth: CGFloat = contentView.frame.width - leftGap - hGap * 2 - rightGap - imageWidth
            titleLabWidth = totalTitleWidth / 2
            subtitleLabWidth = totalTitleWidth - titleLabWidth
        } else {
            titleLabWidth = contentView.frame.width - leftGap - hGap - rightGap - imageWidth
            subtitleLabWidth = 0.0
        }

        titleLab.text = selectorItem.title
        titleLab.frame = CGRect(x: leftGap, y: topGap, width: titleLabWidth, height: contentView.frame.height - topGap - bottomGap)
        contentView.addSubview(titleLab)

        subtitleLab.text = selectorItem.subtitle
        subtitleLab.frame = CGRect(x: titleLab.frame.maxX + hGap, y: topGap, width: subtitleLabWidth, height: contentView.frame.height - topGap - bottomGap)
        contentView.addSubview(subtitleLab)

        var titleColor = "#000000"
        var subtitleColor = "#666666"
        if selectorItem.enabled {
            if selectorItem.selected {
                titleColor = preference.selectedTitleColor
                subtitleColor = preference.selectedSubtitleColor
            } else {
                titleColor = preference.unselectedTitleColor
                subtitleColor = preference.unselectedSubtitleColor
            }
        } else {
            titleColor = preference.disabledColor
            subtitleColor = preference.disabledColor
        }

        titleLab.textColor = UIColor(hexString: titleColor)
        subtitleLab.textColor = UIColor(hexString: subtitleColor)
    }

    private func setUpImageView(preference: SelectorPreference, selectorItem: SelectorBubbleItem, imageWidth: CGFloat) {
        var rightImageView: UIImageView?
        let imageViewX: CGFloat = contentView.frame.width - rightGap - imageWidth
        let imageViewY: CGFloat = (contentView.frame.height - imageWidth) / 2
        let imageViewFrame = CGRect(x: imageViewX, y: imageViewY, width: imageWidth, height: imageWidth)
        if preference.maxSelectNum == 1, preference.resultFromItemTap {
            arrowView.frame = imageViewFrame
            contentView.addSubview(arrowView)
            rightImageView = arrowView
        } else {
            selectView.frame = imageViewFrame
            contentView.addSubview(selectView)
            selectView.isHighlighted = selectorItem.selected
            rightImageView = selectView
        }
        rightImageView?.isHidden = !selectorItem.enabled
    }

    private func setUpUnderline() {
        underline.backgroundColor = UIColor(hexString: "#E6E6E6")
        underline.frame = CGRect(x: 0.0, y: contentView.frame.height - 0.5, width: contentView.frame.width, height: 0.5)
        contentView.addSubview(underline)
    }

    func makeUnderline(show: Bool) {
        underline.isHidden = !show
    }
}
