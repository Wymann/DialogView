//
//  ELKDefaultPage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/13.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

enum ELKDefaultPageStyle {
    case top
    case middle
    case bottom
}

class ELKDefaultPage: UIView {
    typealias DefaultPageButtonClick = () -> Void

    var model: ELKDefaultPageModel

    var position: ELKDefaultPagePosition

    var clickBlock: DefaultPageButtonClick?

    private lazy var contentView: UIView = .init()

    private lazy var imageView: UIImageView = .init()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(hexString: ELKDefaultPageConfig.shared.colors.titleColor)
        titleLabel.font = ELKDefaultPageConfig.titleFont()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.textColor = UIColor(hexString: ELKDefaultPageConfig.shared.colors.subtitleColor)
        subtitleLabel.font = ELKDefaultPageConfig.subtitleFont()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        return subtitleLabel
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(hexString: ELKDefaultPageConfig.shared.colors.buttonTextColor), for: .normal)
        button.setTitleColor(UIColor(hexString: ELKDefaultPageConfig.shared.colors.buttonTextColor + "80"), for: .highlighted)
        button.backgroundColor = UIColor(hexString: ELKDefaultPageConfig.shared.colors.buttonBackgroundColor)
        button.titleLabel?.font = ELKDefaultPageConfig.buttonTextFont()
        return button
    }()

    init(model: ELKDefaultPageModel,
         position: ELKDefaultPagePosition = ELKDefaultPagePosition(),
         clickBlock: DefaultPageButtonClick? = nil) {
        self.model = model
        self.position = position
        self.clickBlock = clickBlock
        super.init(frame: CGRect.zero)
        addViewContents()
        addViewConstraints()
        updateViewContents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ELKDefaultPage {
    private func addViewContents() {
        backgroundColor = UIColor.white
        addSubview(contentView)

        contentView.addSubview(imageView)

        if !model.title.isEmpty {
            contentView.addSubview(titleLabel)
        }

        if !model.subtitle.isEmpty {
            contentView.addSubview(subtitleLabel)
        }

        if !model.buttonText.isEmpty {
            contentView.addSubview(button)
        }
    }

    private func addViewConstraints() {
        var topView: UIView = imageView

        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(ELKDefaultPageConfig.shared.pattern.imageSize)
        }

        if !model.title.isEmpty {
            titleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalTo(contentView)
                make.top.equalTo(topView.snp.bottom).offset(ELKDefaultPageConfig.shared.pattern.imageTitleGap)
            }
            topView = titleLabel
        }

        if !model.subtitle.isEmpty {
            subtitleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalTo(contentView)
                make.top.equalTo(topView.snp.bottom).offset(ELKDefaultPageConfig.shared.pattern.titleSubtitleGap)
            }
            topView = subtitleLabel
        }

        if !model.buttonText.isEmpty {
            let buttonWidth = UILabel.elk.labelSize(text: model.buttonText, font: button.titleLabel?.font).width + ELKDefaultPageConfig.shared.pattern.buttonLeftRightMargin * 2
            let buttonHeight = ELKDefaultPageConfig.shared.pattern.buttonHeight

            button.snp.makeConstraints { make in
                make.centerX.equalTo(contentView)
                make.top.equalTo(topView.snp.bottom).offset(ELKDefaultPageConfig.shared.pattern.titleButtonGap)
                make.size.equalTo(CGSize(width: buttonWidth, height: buttonHeight))
            }
            topView = button
        }

        switch position.style {
        case .top:
            contentView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(ELKDefaultPageConfig.shared.pattern.contentLeftRightMargin)
                make.trailing.equalToSuperview().offset(-ELKDefaultPageConfig.shared.pattern.contentLeftRightMargin)
                make.top.equalToSuperview().offset(position.topGap)
                make.bottom.equalTo(topView.snp.bottom)
            }
        case .middle:
            contentView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(ELKDefaultPageConfig.shared.pattern.contentLeftRightMargin)
                make.trailing.equalToSuperview().offset(-ELKDefaultPageConfig.shared.pattern.contentLeftRightMargin)
                make.centerY.equalToSuperview()
                make.bottom.equalTo(topView.snp.bottom)
            }
        case .bottom:
            contentView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(ELKDefaultPageConfig.shared.pattern.contentLeftRightMargin)
                make.trailing.equalToSuperview().offset(-ELKDefaultPageConfig.shared.pattern.contentLeftRightMargin)
                make.bottom.equalToSuperview().offset(-position.bottomGap)
                make.bottom.equalTo(topView.snp.bottom)
            }
        }
    }

    private func updateViewContents() {
        imageView.image = model.image
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        button.setTitle(model.buttonText, for: .normal)

        button.layer.cornerRadius = ELKDefaultPageConfig.shared.pattern.buttonHeight / 2
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(hexString: ELKDefaultPageConfig.shared.colors.buttonBorderColor)?.cgColor
        button.addTarget(self, action: #selector(clickButton(sender:)), for: UIControl.Event.touchUpInside)
    }
}

extension ELKDefaultPage {
    @objc private func clickButton(sender: UIButton) {
        if let block = clickBlock {
            block()
        }
    }
}
