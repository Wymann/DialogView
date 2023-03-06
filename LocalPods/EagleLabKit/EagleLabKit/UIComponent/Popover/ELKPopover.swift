//
//  ELKPopover.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/1/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

class ELKPopover: UIView {
    static let popoverMaskColor: UInt32 = 0x000000
    static let popoverBgColorAlpha: CGFloat = 0.4
    static let popoverDefaultToastyInterval: CGFloat = 1.5
    static let popoverTopGap: CGFloat = 120.0
    static let popoverBottomGap: CGFloat = 120.0

    enum PopoverPosition {
        case middle // 显示在中间
        case top // 显示在上面
        case bottom // 显示在底部
    }

    enum PopType {
        case toast
        case progress
    }

    typealias PopoverWillAppear = () -> Void

    private var position: PopoverPosition = .middle
    private var type: PopType = .toast
    private var contentView: UIView = .init()

    // MARK: Toasty

    /// 显示 toast 在 window
    /// - Parameter text: 文案
    public class func popToastOnWindow(text: String) {
        var toastyModel = ELKToasty.ToastyModel(type: .normal, title: text)
        toastyModel.checkPosition()
        popToasty(view: keyView(), popPosition: .middle, toastyModel: toastyModel, willAppear: nil)
    }

    /// 显示 toast 在指定视图
    /// - Parameters:
    ///   - view: 指定视图
    ///   - text: 文案
    public class func popToast(view: UIView, text: String) {
        var toastyModel = ELKToasty.ToastyModel(type: .normal, title: text)
        toastyModel.checkPosition()
        popToasty(view: view, popPosition: .middle, toastyModel: toastyModel, willAppear: nil)
    }

    /// 显示 toast 在指定视图，并且指定距离试图上方的偏移距离
    /// - Parameters:
    ///   - view: 指定视图
    ///   - text: 文案
    ///   - topOffset: 距离试图上方的偏移距离
    public class func popToast(view: UIView, text: String, topOffset: CGFloat) {
        var toastyModel = ELKToasty.ToastyModel(type: .normal, title: text, topOffset: topOffset)
        toastyModel.checkPosition()
        popToasty(view: view, popPosition: .middle, toastyModel: toastyModel, willAppear: nil)
    }

    /// 显示 toast 在指定视图，并且指定其他参数
    /// - Parameters:
    ///   - view: 指定视图
    ///   - popPosition: 显示位置
    ///   - text: 文案
    ///   - toastyType: toasty 类型
    ///   - appearBlock: 显示时候回调
    public class func popToast(view: UIView, popPosition: PopoverPosition, text: String, toastyType: ELKToasty.ToastyType, willAppear: @escaping PopoverWillAppear) {
        var toastyModel = ELKToasty.ToastyModel(type: toastyType, title: text)
        toastyModel.checkPosition()
        popToasty(view: view, popPosition: popPosition, toastyModel: toastyModel, willAppear: willAppear)
    }

    /// 显示 toast
    /// - Parameters:
    ///   - view: toast 父视图
    ///   - popPosition: 在父视图中的位置
    ///   - toastyModel: toast 模型
    ///   - willAppear: 显示时候回调
    private class func popToasty(view: UIView?, popPosition: PopoverPosition, toastyModel: ELKToasty.ToastyModel, willAppear: PopoverWillAppear?) {
        if let unwrappedView = view {
            let width: CGFloat = unwrappedView.bounds.width
            let height: CGFloat = unwrappedView.bounds.height

            for popView: UIView in unwrappedView.subviews where popView is ELKPopover {
                popView.removeFromSuperview()
            }

            let pop = ELKPopover(frame: CGRect(x: 0, y: 0, width: width, height: height))
            pop.position = popPosition
            pop.type = .toast
            pop.backgroundColor = toastyModel.showMaskView ? UIColor(hex: popoverMaskColor, alpha: popoverBgColorAlpha) : UIColor.clear
            pop.isUserInteractionEnabled = toastyModel.showMaskView
            unwrappedView.addSubview(pop)

            pop.showToasty(toastyModel: toastyModel, willAppear: willAppear)
        }
    }

    private func showToasty(toastyModel: ELKToasty.ToastyModel, willAppear: PopoverWillAppear?) {
        let toastyMaxWidth: CGFloat = bounds.width - 80.0

        let toast = ELKToasty()
        toast.configToastyView(toastyFrame: CGRect.zero, toastyModel: toastyModel, toastyMaxWidth: toastyMaxWidth)
        addSubview(toast)
        contentView = toast

        let size: CGSize = ELKToasty.toastySize(toastyModel: toastyModel, toastyMaxWidth: toastyMaxWidth)

        toast.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(size)
            if toastyModel.topOffset >= 0 {
                make.top.equalToSuperview().offset(toastyModel.topOffset)
            } else {
                switch self.position {
                case .top: make.top.equalToSuperview().offset(ELKPopover.popoverTopGap)
                case .middle: make.centerY.equalToSuperview()
                case .bottom: make.bottom.equalToSuperview().offset(-ELKPopover.popoverBottomGap)
                }
            }
        }

        if let unwrappedWillAppear = willAppear {
            unwrappedWillAppear()
        }

        alpha = 0

        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        } completion: { _ in
            if !toastyModel.stay {
                let time: CGFloat = toastyModel.interval > 0 ? toastyModel.interval : ELKPopover.popoverDefaultToastyInterval
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    UIView.animate(withDuration: 0.2) {
                        self.alpha = 0
                    } completion: { _ in
                        self.removeFromSuperview()
                    }
                }
            }
        }
    }

    // MARK: Progress

    /// 显示 Progress 在 window
    /// - Parameter text: 文案
    public class func popProgressOnWindow(text: String) {
        let progressModel = ELKProgress.ProgressModel(text: text)
        popProgressView(view: ELKPopover.keyView(), progressModel: progressModel, willAppear: nil)
    }

    /// 显示 Progress 在指定视图
    /// - Parameters:
    ///   - view: 指定视图
    ///   - text: 文案
    public class func popProgress(view: UIView, text: String) {
        let progressModel = ELKProgress.ProgressModel(text: text)
        popProgressView(view: view, progressModel: progressModel, willAppear: nil)
    }

    /// 显示 Progress 在指定视图，并且指定距离试图上方的偏移距离
    /// - Parameters:
    ///   - view: 指定视图
    ///   - text: 文案
    ///   - topOffset: 距离试图上方的偏移距离
    public class func popProgress(view: UIView, text: String, topOffset: CGFloat) {
        let progressModel = ELKProgress.ProgressModel(text: text, topOffset: topOffset)
        popProgressView(view: view, progressModel: progressModel, willAppear: nil)
    }

    /// 显示 Progress 在指定视图，并且指定其他参数
    /// - Parameters:
    ///   - view: 指定视图
    ///   - text: 文案
    ///   - topOffset: 距离试图上方的偏移距离
    ///   - appearBlock: 显示时候回调
    public class func popProgress(view: UIView, text: String, topOffset: CGFloat, willAppear: @escaping PopoverWillAppear) {
        let progressModel = ELKProgress.ProgressModel(text: text, topOffset: topOffset)
        popProgressView(view: view, progressModel: progressModel, willAppear: willAppear)
    }

    /// 显示 Progress
    /// - Parameters:
    ///   - view: toast 父视图
    ///   - progressModel: progress 模型
    ///   - willAppear: 显示时候回调
    private class func popProgressView(view: UIView?, progressModel: ELKProgress.ProgressModel, willAppear: PopoverWillAppear?) {
        if let unwrappedView = view {
            let width: CGFloat = unwrappedView.bounds.width
            let height: CGFloat = unwrappedView.bounds.height

            for popView: UIView in unwrappedView.subviews where popView is ELKPopover {
                popView.removeFromSuperview()
            }

            let pop = ELKPopover(frame: CGRect(x: 0, y: 0, width: width, height: height))
            pop.position = .middle
            pop.type = .progress
            pop.backgroundColor = progressModel.showMaskView ? UIColor(hex: popoverMaskColor, alpha: popoverBgColorAlpha) : UIColor.clear
            unwrappedView.addSubview(pop)

            pop.showProgressView(progressModel: progressModel, willAppear: willAppear)
        }
    }

    private func showProgressView(progressModel: ELKProgress.ProgressModel, willAppear: PopoverWillAppear?) {
        let progress = ELKProgress()
        progress.setUpDetailUI(progressModel: progressModel)
        addSubview(progress)
        contentView = progress

        let size: CGSize = ELKProgress.progressSize(text: progressModel.text)

        progress.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(size)
            if progressModel.topOffset >= 0 {
                make.top.equalToSuperview().offset(progressModel.topOffset)
            } else {
                switch self.position {
                case .top: make.top.equalToSuperview().offset(ELKPopover.popoverTopGap)
                case .middle: make.centerY.equalToSuperview()
                case .bottom: make.bottom.equalToSuperview().offset(-ELKPopover.popoverBottomGap)
                }
            }
        }

        if let unwrappedWillAppear = willAppear {
            unwrappedWillAppear()
        }

        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        } completion: { _ in
            if !progressModel.stay {
                let time: CGFloat = progressModel.interval > 0 ? progressModel.interval : ELKPopover.popoverDefaultToastyInterval
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    UIView.animate(withDuration: 0.2) {
                        self.alpha = 0
                    } completion: { _ in
                        self.removeFromSuperview()
                    }
                }
            }
        }
    }

    // MARK: Common

    /// 移除 window 上的 Popover
    public class func removePopoverOnWindow() {
        ELKPopover.removePopover(superView: ELKPopover.keyView())
    }

    /// 移除指定视图上的 Popover
    /// - Parameter superView: 指定视图
    public class func removePopover(superView: UIView?) {
        if let unwrappedView = superView {
            for subview: UIView in unwrappedView.subviews where subview is ELKPopover {
                UIView.animate(withDuration: 0.2) {
                    subview.alpha = 0
                } completion: { _ in
                    subview.removeFromSuperview()
                }
            }
        }
    }

    /// 移除指定视图上的 Progress
    /// - Parameter superView: 指定视图
    public class func removeProgress(superView: UIView?) {
        if let unwrappedView = superView {
            for subview: UIView in unwrappedView.subviews where subview is ELKPopover {
                if let pop = subview as? ELKPopover, pop.type == .progress {
                    UIView.animate(withDuration: 0.2) {
                        subview.alpha = 0
                    } completion: { _ in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }

    /// 获取 window
    /// - Returns: keyView
    class func keyView() -> UIView? {
        var keyView: UIView? = UIApplication.shared.keyWindow
        if keyView == nil {
            keyView = UIApplication.shared.windows.last
        }
        return keyView
    }
}
