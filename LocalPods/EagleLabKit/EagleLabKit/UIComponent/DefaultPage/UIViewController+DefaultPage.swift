//
//  UIViewController+DefaultPage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/14.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UIViewController {
    /// 显示缺省页（指定位置类型）
    /// - Parameters:
    ///   - model: 缺省页数据
    ///   - style: 位置类型
    ///   - clickBlock: 点击按钮回调
    func showDefaultPage(model: ELKDefaultPageModel,
                         style: ELKDefaultPageStyle,
                         clickBlock: ELKDefaultPage.DefaultPageButtonClick? = nil) {
        base.view.elk.showDefaultPage(model: model,
                                      style: style,
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
        base.view.elk.showDefaultPage(model: model,
                                      topGap: topGap,
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
        base.view.elk.showDefaultPage(model: model,
                                      bottomGap: bottomGap,
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
        base.view.elk.showDefaultPage(model: model,
                                      position: position,
                                      clickBlock: clickBlock)
    }

    /// 去除缺省页
    func hideDefaultPage() {
        base.view.elk.hideDefaultPage()
    }
}
