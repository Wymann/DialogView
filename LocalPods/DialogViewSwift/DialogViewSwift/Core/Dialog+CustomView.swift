//
//  Dialog+CustomView.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

// MARK: 自动显示弹框

extension EagleLabKit where Base: Dialog {
    /// 显示自定义视图弹框（固定高度，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewHeight: 自定义视图高度
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(customView: UIView,
                           customViewHeight: CGFloat,
                           configuration: DialogViewConfig = DialogViewConfig(),
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(customView: customView,
                          customViewHeight: customViewHeight,
                          configuration: configuration,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }

    /// 显示自定义视图弹框（固定 Size，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewSize: 自定义视图 Size
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(customView: UIView,
                           customViewSize: CGSize,
                           configuration: DialogViewConfig = DialogViewConfig(),
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(customView: customView,
                          customViewSize: customViewSize,
                          configuration: configuration,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension EagleLabKit where Base: Dialog {
    /// 自定义视图弹框（固定高度，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewHeight: 自定义视图高度
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(customView: UIView,
                       customViewHeight: CGFloat,
                       configuration: DialogViewConfig = DialogViewConfig(),
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = DialogView()
        view.configDialogViewByCustomHeight(customView: customView,
                                            customViewHeight: customViewHeight,
                                            configuration: configuration)
        view.dialogResult = resultBlock
        return view
    }

    /// 自定义视图弹框（固定 Size，可自定义配置）
    /// - Parameters:
    ///   - customView: 自定义视图
    ///   - customViewSize: 自定义视图 Size
    ///   - configuration: 配置参数
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(customView: UIView,
                       customViewSize: CGSize,
                       configuration: DialogViewConfig = DialogViewConfig(),
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = DialogView()
        view.configDialogViewByCustomSize(customView: customView,
                                          customViewSize: customViewSize,
                                          configuration: configuration)
        view.dialogResult = resultBlock
        return view
    }
}
