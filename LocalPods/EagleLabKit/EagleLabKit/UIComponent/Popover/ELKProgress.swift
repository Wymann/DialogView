//
//  ELKProgress.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/1/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Lottie
import SnapKit
import UIKit

class ELKProgress: UIView {
    // 默认字体大小
    static let progressTitleFontSize: CGFloat = 12.0

    // ProgressView
    static let progressViewWidth: CGFloat = 50.0
    static let progressViewHeight: CGFloat = 50.0
    static let progressAnimationViewWidth: CGFloat = 36.0
    static let progressAnimationViewHeight: CGFloat = 36.0
    static let progressMinWidth: CGFloat = 100.0
    static let progressMinHeight: CGFloat = 100.0

    // 内容距离上下左右的间隔，以及内容之间的纵向间隔
    static let progressLeftGap: CGFloat = 15.0
    static let progressTopGap: CGFloat = 15.0
    static let progressRightGap: CGFloat = 15.0
    static let progressBottomGap: CGFloat = 15.0
    static let progressVGap: CGFloat = 5.0

    struct ProgressModel {
        var text: String = ""
        var interval: CGFloat = 0
        var inProgress: Bool = true
        var stay: Bool = true
        var showMaskView: Bool = false
        var topOffset: CGFloat = -1
    }

    // 默认圆角
    let progressDefaultCorner: CGFloat = 10.0

    // 默认颜色
    let progressBgColorAlpha: CGFloat = 1
    let progressBgColor: UInt32 = 0xFFFFFF
    let progressTitleColor: UInt32 = 0x2D3132

    // 标题颜色
    private var titleColor: UIColor?

    // 最大宽度
    private var maxWidth: CGFloat = 0

    // 数据
    private var model: ProgressModel?

    private lazy var progressView: UIView = {
        let progressView = UIView()
        return progressView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    private lazy var animationView: AnimationView = {
        var animationView = AnimationView(name: AppConfig.default.loadingAnimationJson)
        animationView.contentMode = UIView.ContentMode.scaleAspectFit
        animationView.animationSpeed = 1.5
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        return animationView
    }()

    /// 设置详细 UI
    /// - Parameter progressModel: 数据模型
    public func setUpDetailUI(progressModel: ProgressModel) {
        model = progressModel
        // bgColor
        backgroundColor = UIColor(hex: progressBgColor, alpha: progressBgColorAlpha)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = progressDefaultCorner

        layer.cornerRadius = progressDefaultCorner

        addSubview(titleLabel)
        addSubview(progressView)
        progressView.addSubview(animationView)

        // titleLabel
        if let title = model?.text, !title.isEmpty {
            progressView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(ELKProgress.progressTopGap)
                make.size.equalTo(CGSize(width: ELKProgress.progressViewWidth, height: ELKProgress.progressViewHeight))
            }

            titleLabel.font = UIFont.elk.gothamBookFont(ofSize: ELKProgress.progressTitleFontSize)
            titleLabel.text = model?.text
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(ELKProgress.progressLeftGap)
                make.right.equalToSuperview().offset(-ELKProgress.progressRightGap)
                make.top.equalTo(progressView.snp.bottom).offset(ELKProgress.progressVGap)
            }
        } else {
            progressView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: ELKProgress.progressViewWidth, height: ELKProgress.progressViewHeight))
            }
        }

        animationView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(progressView)
            make.size.equalTo(CGSize(width: ELKProgress.progressAnimationViewWidth, height: ELKProgress.progressAnimationViewHeight))
        }

        if let inProgress = model?.inProgress, inProgress == true {
            start()
        }
    }

    /// 开始动画
    public func start() {
        animationView.play()
    }

    /// 结束动画
    public func stop() {
        animationView.stop()
    }

    class func progressSize(text: String) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0

        if !text.isEmpty {
            let textFont = UIFont.elk.gothamBookFont(ofSize: progressTitleFontSize)

            let textSize: CGSize = UILabel.elk.labelSize(text: text, font: textFont)
            let contentWidth: CGFloat = textSize.width > progressViewWidth ? textSize.width : progressViewWidth

            width = progressLeftGap + contentWidth + progressRightGap
            width = width > progressMinWidth ? width : progressMinWidth

            height = progressTopGap + progressViewHeight + progressVGap + textSize.height + progressBottomGap
            height = height > progressMinHeight ? height : progressMinHeight
        } else {
            width = progressMinWidth
            height = progressMinHeight
        }

        return CGSize(width: width, height: height)
    }
}
