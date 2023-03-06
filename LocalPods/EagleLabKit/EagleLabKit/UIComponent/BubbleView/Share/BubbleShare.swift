//
//  BubbleShare.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/10/8.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

class BubbleShare: UIView {
    static let shareItemHeight: CGFloat = 90.0
    static let shareItemMinimumSpacing: CGFloat = 15.0
    static let shareCollectionViewInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 25.0, right: 15.0)
    static let shareDefaultRowCount: Int = 4
    static let shareTitleTopGap: CGFloat = 20.0 // Share 标题顶部距离
    static let shareTitleBottomGap: CGFloat = 20.0 // Share 标题底部距离
    static let shareTitleBetweenGap: CGFloat = 8.0 // Share 标题与副标题距离

    static let shareGapLine: CGFloat = 8.0 // 底部横隔线的高度
    static let shareButtonHeight: CGFloat = 56.0 // 按钮高度

    static let shareTitleLeftRightGap: CGFloat = 10.0 // Share 标题左右距离
    static let shareTitleFontSize: CGFloat = 18.0 // Share 标题字体大小
    static let shareSubtitleFontSize: CGFloat = 16.0 // Share 副标题字体大小

    private let shareButtonFontSize: CGFloat = 18.0 // Share 按钮字体大小
    private let cellReuseIdentifier: String = "BubbleShareCell"

    // 点击 Share 选项回调，Bool 表示是否关闭 Share
    typealias BubbleShareItemClick = (_ itemIndex: Int) -> Bool

    // 点击底部按钮回调，Bool 表示是否关闭 Share
    typealias BubbleShareButtonClick = (_ buttonIndex: Int) -> Bool

    var models: [ShareModel]
    var configuration: ShareConfiguration
    var itemClickBlock: BubbleShareItemClick?
    var buttonClickBlock: BubbleShareButtonClick?

    var bubbleView: BubbleView?

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = BubbleConfig.boldFont(ofSize: BubbleShare.shareTitleFontSize)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(hexString: BubbleConfig.commonColor()) ?? UIColor.black
        return titleLabel
    }()

    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = BubbleConfig.normalFont(ofSize: BubbleShare.shareSubtitleFontSize)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(hexString: BubbleConfig.commonColor()) ?? UIColor.darkGray
        return subtitleLabel
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = BubbleShare.shareCollectionViewInsets
        layout.minimumLineSpacing = BubbleShare.shareItemMinimumSpacing
        layout.minimumInteritemSpacing = BubbleShare.shareItemMinimumSpacing

        let totalWidth = self.frame.width - BubbleShare.shareCollectionViewInsets.left - BubbleShare.shareCollectionViewInsets.right
        let rowCount = configuration.rowCount <= 0 ? BubbleShare.shareDefaultRowCount : configuration.rowCount
        let itemWidth = (totalWidth - CGFloat(rowCount - 1) * BubbleShare.shareItemMinimumSpacing) / CGFloat(rowCount)
        layout.itemSize = CGSize(width: floor(itemWidth), height: BubbleShare.shareItemHeight)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BubbleShareCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

        return collectionView
    }()

    private lazy var bottomGapLine: UIView = {
        let bottomGapLine = UIView()
        bottomGapLine.backgroundColor = UIColor(hexString: "#F4F4F4")
        return bottomGapLine
    }()

    init(frame: CGRect,
         models: [ShareModel],
         configuration: ShareConfiguration = ShareConfiguration(),
         itemClickBlock: BubbleShareItemClick? = nil,
         buttonClickBlock: BubbleShareButtonClick? = nil) {
        self.models = models
        self.configuration = configuration
        self.itemClickBlock = itemClickBlock
        self.buttonClickBlock = buttonClickBlock
        super.init(frame: frame)

        setUpDetailUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BubbleShare {
    private func setUpDetailUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 12.0
        clipsToBounds = true

        if !configuration.bubbleTitle.isEmpty {
            let titleX = BubbleShare.shareTitleLeftRightGap
            let titleY = BubbleShare.shareTitleTopGap
            let titleW = bounds.width - BubbleShare.shareTitleLeftRightGap * 2
            let titleH = UILabel.elk.labelHeight(text: configuration.bubbleTitle,
                                                 width: titleW,
                                                 font: titleLabel.font)
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            titleLabel.text = configuration.bubbleTitle
            addSubview(titleLabel)
        }

        if !configuration.bubbleSubtitle.isEmpty {
            let subtitleX = BubbleShare.shareTitleLeftRightGap
            let subtitleY = !configuration.bubbleTitle.isEmpty ? titleLabel.frame.maxY + BubbleShare.shareTitleBetweenGap : BubbleShare.shareTitleTopGap
            let subtitleW = bounds.width - BubbleShare.shareTitleLeftRightGap * 2
            let subtitleH = UILabel.elk.labelHeight(text: configuration.bubbleSubtitle,
                                                    width: subtitleW,
                                                    font: subtitleLabel.font)
            subtitleLabel.frame = CGRect(x: subtitleX, y: subtitleY, width: subtitleW, height: subtitleH)
            subtitleLabel.text = configuration.bubbleSubtitle
            addSubview(subtitleLabel)
        }

        let collectionViewY = !configuration.bubbleSubtitle.isEmpty ? subtitleLabel.frame.maxY + BubbleShare.shareTitleBottomGap : titleLabel.frame.maxY + BubbleShare.shareTitleBottomGap
        let collectionViewH: CGFloat = BubbleShare.bubbleCollectionViewHeight(models: models,
                                                                              configuration: configuration,
                                                                              shareWidth: frame.width)

        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: frame.width, height: collectionViewH)
        addSubview(collectionView)

        setUpButtons()
    }

    private func setUpButtons() {
        if !configuration.buttons.isEmpty {
            let bottomGapLineX = 0.0
            let bottomGapLineY = collectionView.frame.maxY
            let bottomGapLineW = frame.width
            let bottomGapLineH = BubbleShare.shareGapLine
            bottomGapLine.frame = CGRect(x: bottomGapLineX, y: bottomGapLineY, width: bottomGapLineW, height: bottomGapLineH)
            addSubview(bottomGapLine)

            let buttonWidth = CGFloat(frame.width) / CGFloat(configuration.buttons.count)
            for (index, buttonTitle) in configuration.buttons.enumerated() {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: bottomGapLine.frame.maxY, width: buttonWidth, height: BubbleShare.shareButtonHeight)
                button.titleLabel?.font = BubbleConfig.normalFont(ofSize: shareButtonFontSize)
                button.setTitle(buttonTitle, for: .normal)
                button.setTitleColor(UIColor(hexString: BubbleConfig.commonColor()), for: .normal)
                button.setTitleColor(UIColor(hexString: BubbleConfig.commonColor() + "80"), for: .highlighted)
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
    }
}

@objc
extension BubbleShare {
    private func clickBottomButton(_ button: UIButton) {
        let index = button.tag - 999
        if let block = buttonClickBlock {
            let close = block(index)
            if close { bubbleView?.closeBubbleView() }
        } else {
            bubbleView?.closeBubbleView()
        }
    }
}

extension BubbleShare: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? BubbleShareCell
        let unwrappedCell = cell ?? BubbleShareCell()
        unwrappedCell.model = models[indexPath.row]
        return unwrappedCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = itemClickBlock {
            let close = block(indexPath.row)
            if close { bubbleView?.closeBubbleView() }
        }
    }
}

extension BubbleShare {
    static func shareWidth() -> CGFloat {
        let width: CGFloat = BubbleView.bubbleScreenWidth < BubbleView.bubbleScreenHeight ? BubbleView.bubbleScreenWidth : BubbleView.bubbleScreenHeight
        return width - 16.0
    }

    static func bubbleShareHeight(models: [ShareModel],
                                  configuration: ShareConfiguration = ShareConfiguration(),
                                  shareWidth: CGFloat) -> CGFloat {
        var shareHeight: CGFloat = 0.0
        if !configuration.bubbleTitle.isEmpty || !configuration.bubbleSubtitle.isEmpty {
            shareHeight += shareTitleTopGap

            if !configuration.bubbleTitle.isEmpty {
                let titleW = shareWidth - shareTitleLeftRightGap * 2
                let titleH = UILabel.elk.labelHeight(text: configuration.bubbleTitle,
                                                     width: titleW,
                                                     font: BubbleConfig.boldFont(ofSize: shareTitleFontSize))
                shareHeight += titleH
            }

            if !configuration.bubbleSubtitle.isEmpty {
                let subtitleW = shareWidth - shareTitleLeftRightGap * 2
                let subtitleH = UILabel.elk.labelHeight(text: configuration.bubbleSubtitle,
                                                        width: subtitleW,
                                                        font: BubbleConfig.normalFont(ofSize: BubbleShare.shareSubtitleFontSize))
                shareHeight += subtitleH
            }

            if !configuration.bubbleTitle.isEmpty, !configuration.bubbleSubtitle.isEmpty {
                shareHeight += shareTitleBetweenGap
            }

            shareHeight += shareTitleBottomGap
        }

        let collectionViewHeight: CGFloat = BubbleShare.bubbleCollectionViewHeight(models: models,
                                                                                   configuration: configuration,
                                                                                   shareWidth: shareWidth)

        shareHeight += collectionViewHeight

        if !configuration.buttons.isEmpty {
            shareHeight += (shareGapLine + shareButtonHeight)
        }

        return shareHeight
    }

    private static func bubbleCollectionViewHeight(models: [ShareModel],
                                                   configuration: ShareConfiguration = ShareConfiguration(),
                                                   shareWidth: CGFloat) -> CGFloat {
        guard !models.isEmpty else { return 0.0 }
        let rowCount = configuration.rowCount <= 0 ? BubbleShare.shareDefaultRowCount : configuration.rowCount
        var lineCount = ceil(CGFloat(models.count) / CGFloat(rowCount))
        lineCount = min(lineCount, 3)
        return ceil(lineCount * BubbleShare.shareItemHeight + (lineCount - 1) * BubbleShare.shareItemMinimumSpacing) + BubbleShare.shareCollectionViewInsets.top + BubbleShare.shareCollectionViewInsets.bottom
    }
}
