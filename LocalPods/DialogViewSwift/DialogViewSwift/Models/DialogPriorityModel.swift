//
//  DialogPriorityModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/23.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class PriorityModelConfig {
    typealias ConfigurationTimeChangedBlock = (_ timeInQueue: CGFloat, _ timeOnShow: CGFloat) -> Void

    public var timeChangedBlock: ConfigurationTimeChangedBlock?

    public var dialogView: DialogView = .init() // 弹框视图

    public var priorityType: DialogPriorityModel.DialogPriorityType = .priorityB // 优先级

    public var priorityValue: Int = 0 // 优先值

    // 在队列中等待时长（大于0才生效）
    public var timeInQueue: CGFloat = 0.0 {
        didSet {
            if let block = timeChangedBlock {
                block(timeInQueue, timeOnShow)
            }
        }
    }

    // 在显示中等待时长（大于0才生效）
    public var timeOnShow: CGFloat = 0.0 {
        didSet {
            if let block = timeChangedBlock {
                block(timeInQueue, timeOnShow)
            }
        }
    }

    // 是否只显示一次
    // YES：（默认）显示之后，后面被更高优先级的弹框挤下去，后面也不再显示
    // NO：被更高优先级的弹框挤下去，还会在队列中等待
    public var showOnce: Bool = true

    // 是否为队列中最后一个
    // YES：队列中最后一个，之后的弹框不会再显示，也不允许再增加，直到这个弹框关闭
    // NO：（默认）
    public var endDialog: Bool = false
}

class PriorityModelControl {
    typealias OverTimeOnShowBlock = (_ dialogView: DialogView?) -> Void

    public var displayed: Bool = false // 是否已经显示过

    public var needWaitInQueue: Bool = false // 是否需要在队列中计时

    public var overTimeInQueue: Bool = false // 是否在队列中已经超时

    public var timerInQueue: Timer? // 队列计时器

    public var needWaitOnShow: Bool = false // 是否需要在显示中计时

    public var overTimeOnShow: Bool = false // 是否在显示中已经超时

    public var timerOnShow: Timer? // 显示计时器

    public var timeOnShowBlock: OverTimeOnShowBlock? // 显示超时回调
}

class DialogPriorityModel {
    enum DialogPriorityType: Int {
        // 优先级最高的全局弹框（比如强制升级等）
        case priorityS = 0

        // 普通的全局弹框 (Push 弹框等)
        case priorityA = 1

        // 局部弹框一般都放这里
        case priorityB = 2

        // 其它
        case priorityC = 3
    }

    // 弹框便捷优先级设置 （0 到 20）
    enum DialogConvenientType: Int {
        case convenientP0 = 0 // priorityA 200
        case convenientP1 = 1 // priorityA 190
        case convenientP2 = 2 // priorityA 180
        case convenientP3 = 3 // priorityA 170
        case convenientP4 = 4 // priorityA 160
        case convenientP5 = 5 // priorityA 150
        case convenientP6 = 6 // priorityA 140
        case convenientP7 = 7 // priorityA 130
        case convenientP8 = 8 // priorityA 120
        case convenientP9 = 9 // priorityA 110
        case convenientP10 = 10 // priorityA 100
        case convenientP11 = 11 // priorityA 90
        case convenientP12 = 12 // priorityA 80
        case convenientP13 = 13 // priorityA 70
        case convenientP14 = 14 // priorityA 60
        case convenientP15 = 15 // priorityA 50
        case convenientP16 = 16 // priorityA 40
        case convenientP17 = 17 // priorityA 30
        case convenientP18 = 18 // priorityA 20
        case convenientP19 = 19 // priorityA 10
        case convenientP20 = 20 // priorityA 0
    }

    // 优先级配置
    public var configuration: PriorityModelConfig = .init() {
        didSet {
            configuration.timeChangedBlock = { (_ timeInQueue: CGFloat, _ timeOnShow: CGFloat) in
                self.checkConfiguration(timeInQueue: timeInQueue, timeOnShow: timeOnShow)
            }
        }
    }

    // 内部实现的控制
    public var control: PriorityModelControl = .init()

    public func checkConfiguration() {
        checkConfiguration(timeInQueue: configuration.timeInQueue, timeOnShow: configuration.timeOnShow)
    }

    private func checkConfiguration(timeInQueue: CGFloat, timeOnShow: CGFloat) {
        control.needWaitInQueue = timeInQueue > 0.0
        control.needWaitOnShow = timeOnShow > 0.0
    }

    public class func dialogPriorityModel(configuration: PriorityModelConfig) -> DialogPriorityModel {
        let model = DialogPriorityModel()
        model.configuration = configuration
        model.checkConfiguration(timeInQueue: configuration.timeInQueue, timeOnShow: configuration.timeOnShow)
        return model
    }

    public class func dialogPriorityModel(dialogView: DialogView) -> DialogPriorityModel {
        return dialogPriorityModel(dialogView: dialogView,
                                   priorityType: nil,
                                   priorityValue: nil)
    }

    public class func dialogPriorityModel(dialogView: DialogView,
                                          priorityType: DialogPriorityType?,
                                          priorityValue: Int?) -> DialogPriorityModel {
        let model = DialogPriorityModel()

        model.configuration.dialogView = dialogView

        if let type = priorityType {
            model.configuration.priorityType = type
        }

        if let value = priorityValue {
            model.configuration.priorityValue = value
        }

        return model
    }

    public class func dialogPriorityModel(dialogView: DialogView,
                                          convenientType: DialogConvenientType) -> DialogPriorityModel {
        let model = DialogPriorityModel()

        model.configuration.dialogView = dialogView

        let totalConvenientTypes = 20
        model.configuration.priorityType = .priorityA
        model.configuration.priorityValue = (totalConvenientTypes - convenientType.rawValue) * 10

        return model
    }

    public func startCountTimeInQueue() {
        if control.timerInQueue != nil {
            return
        }

        control.timerInQueue = Timer.scheduledTimer(withTimeInterval: configuration.timeInQueue,
                                                    repeats: true,
                                                    block: { _ in
                                                        self.control.overTimeInQueue = true
                                                        self.stopCountTimeInQueue()
                                                    })
        if let timer = control.timerInQueue {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    public func stopCountTimeInQueue() {
        if let timer = control.timerInQueue {
            timer.invalidate()
            control.timerInQueue = nil
        }
    }

    public func startCountTimeOnShow() {
        if control.timerOnShow != nil {
            return
        }

        control.timerOnShow = Timer.scheduledTimer(withTimeInterval: configuration.timeOnShow,
                                                   repeats: true,
                                                   block: { _ in
                                                       self.control.overTimeOnShow = true
                                                       if let block = self.control.timeOnShowBlock {
                                                           block(self.configuration.dialogView)
                                                       }
                                                       self.stopCountTimeOnShow()
                                                   })
        if let timer = control.timerOnShow {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    public func stopCountTimeOnShow() {
        if let timer = control.timerOnShow {
            timer.invalidate()
            control.timerOnShow = nil
        }
    }

    deinit {
        self.stopCountTimeInQueue()
        self.stopCountTimeOnShow()
    }

    private func restartCountTimeOnShow(time: CGFloat) {
        var needStartCount = false
        if control.timerOnShow != nil {
            needStartCount = true
            stopCountTimeOnShow()
        }

        configuration.timeOnShow = time

        if needStartCount {
            startCountTimeOnShow()
        }
    }
}
