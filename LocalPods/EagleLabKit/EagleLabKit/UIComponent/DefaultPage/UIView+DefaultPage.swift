//
//  UIView+DefaultPage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/13.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UIView {
    /// 显示缺省页（指定位置类型）
    /// - Parameters:
    ///   - model: 缺省页数据
    ///   - style: 位置类型
    ///   - clickBlock: 点击按钮回调
    func showDefaultPage(model: ELKDefaultPageModel,
                         style: ELKDefaultPageStyle,
                         clickBlock: ELKDefaultPage.DefaultPageButtonClick? = nil) {
        let position = ELKDefaultPagePosition(style: style)
        showDefaultPage(model: model,
                        position: position,
                        clickBlock: clickBlock)
    }

    /// 显示缺省页（固定顶部距离）
    /// - Parameters:
    ///   - model: 缺省页数据
    ///   - topGap: 顶部距离
    ///   - clickBlock: 点击按钮回调
    func showDefaultPage(model: ELKDefaultPageModel,
                         topGap: CGFloat,
                         clickBlock: ELKDefaultPage.DefaultPageButtonClick? = nil) {
        let position = ELKDefaultPagePosition(style: .top, topGap: topGap)
        showDefaultPage(model: model,
                        position: position,
                        clickBlock: clickBlock)
    }

    /// 显示缺省页（固定底部距离）
    /// - Parameters:
    ///   - model: 缺省页数据
    ///   - bottomGap: 底部距离
    ///   - clickBlock: 点击按钮回调
    func showDefaultPage(model: ELKDefaultPageModel,
                         bottomGap: CGFloat,
                         clickBlock: ELKDefaultPage.DefaultPageButtonClick? = nil) {
        let position = ELKDefaultPagePosition(style: .bottom, bottomGap: bottomGap)
        showDefaultPage(model: model,
                        position: position,
                        clickBlock: clickBlock)
    }

    /// 显示缺省页
    /// - Parameters:
    ///   - model: 缺省页数据
    ///   - position: 缺省页内容位置
    ///   - clickBlock: 点击按钮回调
    func showDefaultPage(model: ELKDefaultPageModel,
                         position: ELKDefaultPagePosition = ELKDefaultPagePosition(),
                         clickBlock: ELKDefaultPage.DefaultPageButtonClick? = nil) {
        hideDefaultPage()

        let defaultPage = ELKDefaultPage(model: model,
                                         position: position,
                                         clickBlock: clickBlock)
        defaultPage.tag = ELKDefaultPageConfig.defaultPageTag
        base.addSubview(defaultPage)
        if base.frame.size.width > 0, base.frame.size.height > 0 {
            defaultPage.frame = base.bounds
        } else {
            defaultPage.snp.makeConstraints { make in
                make.top.leading.bottom.trailing.equalTo(base.safeAreaLayoutGuide)
            }
        }
    }

    /// 去除缺省页
    func hideDefaultPage() {
        let oldView = base.viewWithTag(ELKDefaultPageConfig.defaultPageTag)
        if oldView != nil {
            oldView?.removeFromSuperview()
        }
    }
}
