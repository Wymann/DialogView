//
//  Dialog+NetImage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/30.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

// MARK: 自动显示弹框

extension EagleLabKit where Base: Dialog {
    /// 显示网络图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（纯文本）
    ///   - netImage: 网络图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(title: String,
                           subtitle: String,
                           netImage: DialogNetImage,
                           buttons: [String]?,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let dialogImage = DialogImage(netImage: netImage)
        return Dialog.elk.showDialog(title: title,
                                     subtitle: DialogSubtitle(subtitle: subtitle),
                                     image: dialogImage,
                                     buttons: buttons,
                                     resultBlock: resultBlock)
    }
}

// MARK: 生成弹框，不自动显示

extension EagleLabKit where Base: Dialog {
    /// 网络图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（纯文本）
    ///   - netImage: 网络图片及配置
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(title: String,
                       subtitle: String,
                       netImage: DialogNetImage,
                       buttons: [String]?,
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let dialogImage = DialogImage(netImage: netImage)
        return Dialog.elk.dialog(title: title,
                                 subtitle: DialogSubtitle(subtitle: subtitle),
                                 image: dialogImage,
                                 buttons: buttons,
                                 resultBlock: resultBlock)
    }
}
