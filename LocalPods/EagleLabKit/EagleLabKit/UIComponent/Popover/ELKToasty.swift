//
//  ELKToasty.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/1/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import SnapKit
import UIKit

class ELKToasty: UIView {
    static let toastyTitleFontSize: CGFloat = 14.0

    // 内容距离上下左右的间隔，以及内容之间的横向和纵向间隔
    static let toastyLeftGap: CGFloat = 24.0
    static let toastyRightGap: CGFloat = 24.0

    static let toastyTopGap: CGFloat = 24.0
    static let toastyBottomGap: CGFloat = 24.0

    static let toastyLeftGap2: CGFloat = 15.0
    static let toastyRightGap2: CGFloat = 15.0

    static let toastyTopGap2: CGFloat = 30.0
    static let toastyBottomGap2: CGFloat = 30.0

    static let toastyHGap: CGFloat = 8.0
    static let toastyVGap: CGFloat = 8.0

    // 图片宽高
    static let toastyImageWidth = 18.0
    static let toastyImageHeight = 18.0
    static let toastyImageWidth2 = 40.0
    static let toastyImageHeight2 = 40.0

    enum ImageTextPosition {
        case imageLeftTextRight // 图片在左，文字在右
        case imageRightTextLeft // 图片在右，文字在左
        case imageTopTextBottom // 图片在上，文字在下
        case imageBottomTextTop // 图片在下，文字在上
    }

    enum ToastyType {
        case normal // 普通（不带图片）
        case success // 失败
        case failure // 成功
        case information // 提示
    }

    struct ToastyModel {
        var imageTextPosition: ImageTextPosition = .imageLeftTextRight
        var type: ToastyType = .normal
        var title: String = ""
        var image: UIImage?
        var interval: CGFloat = 0
        var topOffset: CGFloat = -1
        var stay: Bool = false
        var showMaskView: Bool = false

        mutating func checkPosition() {
            switch type {
            case .normal: imageTextPosition = .imageLeftTextRight
            case .success:
                image = UIImage(named: "ToastSuccess")
                imageTextPosition = .imageLeftTextRight
            case .failure:
                image = UIImage(named: "ToastFailure")
                imageTextPosition = .imageLeftTextRight
            case .information:
                image = UIImage(named: "ToastInfo")
                imageTextPosition = .imageLeftTextRight
            }
        }
    }

    let toastyBgColorAlpha: CGFloat = 0.7
    let toastyBgColor: UInt32 = 0x000000
    let toastyTitleColor: UInt32 = 0xFFFFFF

    // 标题颜色
    private var titleColor: UIColor?

    // 最大宽度
    private var maxWidth: CGFloat = 0

    // 圆角
    private var cornerRadius: CGFloat = 8.0

    // 数据模型
    private var model: ToastyModel?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        return label
    }()

    private lazy var imageView: UIImageView = {
        let toastyImageView = UIImageView()
        return toastyImageView
    }()

    /// 配置 Toasty 样式和数据
    /// - Parameters:
    ///   - toastyFrame: Toasty Frame
    ///   - toastyModel: Toasty 数据
    ///   - toastyMaxWidth: Toasty 最大宽度
    public func configToastyView(toastyFrame: CGRect, toastyModel: ToastyModel, toastyMaxWidth: CGFloat) {
        frame = toastyFrame
        model = toastyModel
        maxWidth = toastyMaxWidth
        if model != nil {
            configToastyDetailUI()
        }
    }

    /// 配置 Toasty 样式和数据
    /// - Parameters:
    ///   - toastyFrame: Toasty Frame
    ///   - toastyMaxWidth: Toasty 最大宽度
    public func changeToastyViewUI(toastyFrame: CGRect, toastyMaxWidth: CGFloat) {
        frame = toastyFrame
        maxWidth = toastyMaxWidth
        if model != nil {
            configToastyDetailUI()
        }
    }

    private func configToastyDetailUI() {
        // bgColor
        backgroundColor = UIColor(hex: toastyBgColor, alpha: toastyBgColorAlpha)
        layer.cornerRadius = cornerRadius

        // titleLabel
        if let title = model?.title, !title.isEmpty {
            titleColor = UIColor(hex: toastyTitleColor)
            titleLabel.font = UIFont.elk.gothamBookFont(ofSize: ELKToasty.toastyTitleFontSize)
            titleLabel.text = model?.title
        }

        // imageView
        if model?.image != nil {
            imageView.image = model?.image
        }

        // 依据图片和文字排列类型布局
        switch model?.imageTextPosition {
        case .imageLeftTextRight: setUpImageLeftTextRight()
        case .imageRightTextLeft: setUpImageRightTextLeft()
        case .imageTopTextBottom: setUpImageTopTextBottom()
        case .imageBottomTextTop: setUpImageBottomTextTop()
        case .none: setUpImageLeftTextRight()
        }
    }

    private func setUpImageLeftTextRight() {
        var startToastyX: CGFloat = ELKToasty.toastyLeftGap
        var leftConstraint: ConstraintItem = snp.leading

        if model?.image != nil {
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(startToastyX)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: ELKToasty.toastyImageWidth, height: ELKToasty.toastyImageHeight))
            }
            startToastyX = ELKToasty.toastyHGap
            leftConstraint = imageView.snp.trailing
        }

        if let title = model?.title, !title.isEmpty {
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(leftConstraint).offset(startToastyX)
                make.trailing.equalToSuperview().offset(-ELKToasty.toastyRightGap)
                make.centerY.equalToSuperview()
            }
        }
    }

    private func setUpImageRightTextLeft() {
        var endToastyX: CGFloat = ELKToasty.toastyRightGap
        var rightConstraint: ConstraintItem = snp.trailing

        if model?.image != nil {
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-endToastyX)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: ELKToasty.toastyImageWidth, height: ELKToasty.toastyImageHeight))
            }
            rightConstraint = imageView.snp.leading
            endToastyX = ELKToasty.toastyHGap
        }

        if let title = model?.title, !title.isEmpty {
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.trailing.equalTo(rightConstraint).offset(-endToastyX)
                make.leading.equalToSuperview().offset(ELKToasty.toastyLeftGap)
                make.centerY.equalToSuperview()
            }
        }
    }

    private func setUpImageTopTextBottom() {
        var startToastyY: CGFloat = ELKToasty.toastyTopGap2
        var topConstraint: ConstraintItem = snp.top

        if model?.image != nil {
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(startToastyY)
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: ELKToasty.toastyImageWidth, height: ELKToasty.toastyImageHeight))
            }
            startToastyY = ELKToasty.toastyVGap
            topConstraint = imageView.snp.bottom
        }

        if let title = model?.title, !title.isEmpty {
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(topConstraint).offset(startToastyY)
                make.trailing.equalToSuperview().offset(-ELKToasty.toastyRightGap2)
                make.leading.equalToSuperview().offset(ELKToasty.toastyLeftGap2)
                make.bottom.equalToSuperview().offset(-ELKToasty.toastyBottomGap2)
            }
        }
    }

    private func setUpImageBottomTextTop() {
        var endToastyY: CGFloat = ELKToasty.toastyBottomGap2
        var bottomConstraint: ConstraintItem = snp.bottom

        if model?.image != nil {
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-endToastyY)
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: ELKToasty.toastyImageWidth, height: ELKToasty.toastyImageHeight))
            }
            bottomConstraint = imageView.snp.bottom
            endToastyY = ELKToasty.toastyVGap
        }

        if let title = model?.title, !title.isEmpty {
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.bottom.equalTo(bottomConstraint).offset(-endToastyY)
                make.trailing.equalToSuperview().offset(-ELKToasty.toastyRightGap2)
                make.leading.equalToSuperview().offset(ELKToasty.toastyLeftGap2)
                make.top.equalToSuperview().offset(ELKToasty.toastyTopGap2)
            }
        }
    }

    /// 获取 Toasty Size
    /// - Parameters:
    ///   - toastyModel: 数据模型
    ///   - toastyMaxWidth: Toasty 最大宽度
    /// - Returns: size
    class func toastySize(toastyModel: ToastyModel, toastyMaxWidth: CGFloat) -> CGSize {
        let titleFont = UIFont.elk.gothamBookFont(ofSize: toastyTitleFontSize)
        let titleLabelSize = UILabel.elk.labelSize(text: toastyModel.title, font: titleFont)

        var width: CGFloat = titleLabelSize.width
        var height: CGFloat = titleLabelSize.height
        if toastyModel.imageTextPosition == .imageLeftTextRight || toastyModel.imageTextPosition == .imageRightTextLeft {
            width += (toastyLeftGap + toastyRightGap)
            height += (toastyTopGap + toastyBottomGap)

            if toastyModel.image != nil {
                width += (toastyImageWidth + toastyHGap)
            }
        } else {
            width += (toastyLeftGap2 + toastyRightGap2)
            height += (toastyTopGap2 + toastyBottomGap2)

            if toastyModel.image != nil {
                height += (toastyImageHeight2 + toastyVGap)
            }
        }

        if width > toastyMaxWidth {
            width = toastyMaxWidth

            var textWidth: CGFloat = 0

            if toastyModel.image != nil && (toastyModel.imageTextPosition == .imageLeftTextRight || toastyModel.imageTextPosition == .imageRightTextLeft) {
                textWidth = width - (toastyImageWidth + toastyHGap)
                textWidth -= (toastyLeftGap + toastyRightGap)
            } else {
                textWidth = width - (toastyLeftGap + toastyRightGap)
            }

            var fixedHeight: CGFloat = UILabel.elk.labelHeight(text: toastyModel.title, width: textWidth, font: titleFont)
            var fixedWidth: CGFloat = textWidth

            if toastyModel.imageTextPosition == .imageLeftTextRight || toastyModel.imageTextPosition == .imageRightTextLeft {
                fixedWidth += (toastyLeftGap + toastyRightGap)
                fixedHeight += (toastyTopGap + toastyBottomGap)

                if toastyModel.image != nil {
                    fixedWidth += (toastyImageWidth + toastyHGap)
                }
            } else {
                fixedWidth += (toastyLeftGap2 + toastyRightGap2)
                fixedHeight += (toastyTopGap2 + toastyBottomGap2)

                if toastyModel.image != nil {
                    fixedHeight += (toastyImageHeight2 + toastyVGap)
                }
            }

            return CGSize(width: fixedWidth, height: fixedHeight)
        }

        return CGSize(width: width, height: height)
    }
}
