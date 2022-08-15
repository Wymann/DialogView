//
//  Bubble.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class Bubble: NSObject {
    private var prioritySArray: [BubblePriorityModel] = []
    private var priorityAArray: [BubblePriorityModel] = []
    private var priorityBArray: [BubblePriorityModel] = []
    private var priorityCArray: [BubblePriorityModel] = []
    private var currentPriorityModel: BubblePriorityModel?

    static let sharedInstance = Bubble()

    // MARK: Methods

    /// 添加一个弹框
    /// - Parameters:
    ///   - bubbleView: 弹框
    ///   - priorityType: 优先级
    ///   - priorityValue: 优先值
    /// - Returns: BubblePriorityModel
    @discardableResult
    class func addBubble(bubbleView: BubbleView,
                         priorityType: BubblePriorityModel.BubblePriorityType?,
                         priorityValue: Int?) -> BubblePriorityModel {
        let model = Bubble.sharedInstance.addBubble(bubbleView: bubbleView,
                                                    priorityType: priorityType,
                                                    priorityValue: priorityValue)
        Bubble.sharedInstance.checkCurrentPriorityModel()
        return model
    }

    /// 添加一个弹框（priorityType 为 BubblePriorityB， priorityValue 为0）
    /// - Parameter bubbleView: 弹框
    /// - Returns: BubblePriorityModel
    @discardableResult
    class func addBubble(bubbleView: BubbleView) -> BubblePriorityModel {
        let model = Bubble.sharedInstance.addBubble(bubbleView: bubbleView,
                                                    priorityType: .priorityB,
                                                    priorityValue: 0)
        Bubble.sharedInstance.checkCurrentPriorityModel()
        return model
    }

    /// 添加多个弹框（priorityType 为 BubblePriorityB， priorityValue 为0），依次弹出
    /// - Parameter bubbleViews: 弹框集合
    /// - Returns: [BubblePriorityModel]
    @discardableResult
    class func addBubbles(bubbleViews: [BubbleView]) -> [BubblePriorityModel] {
        var models: [BubblePriorityModel] = []

        for bubbleView in bubbleViews {
            let model = Bubble.sharedInstance.addBubble(bubbleView: bubbleView,
                                                        priorityType: .priorityB,
                                                        priorityValue: 0)
            models.append(model)
        }

        Bubble.sharedInstance.addBubbles(priorityModels: models)
        Bubble.sharedInstance.checkCurrentPriorityModel()
        return models
    }

    /// 添加多个弹框模型
    /// - Parameter priorityModels: 弹框模型集合
    class func addBubbles(priorityModels: [BubblePriorityModel]) {
        Bubble.sharedInstance.addBubbles(priorityModels: priorityModels)
        Bubble.sharedInstance.checkCurrentPriorityModel()
    }

    /// 移除所有弹框
    class func removeAllBubble() {
        Bubble.sharedInstance.removeAllBubble()
    }

    /// 移除所有弹框
    /// - Parameter exceptCurrentBubble: 是否除去当前正在显示的（true 的话当前显示的弹框不移除）
    class func removeAllBubble(exceptCurrentBubble: Bool) {
        Bubble.sharedInstance.removeAllBubble(exceptCurrentBubble: exceptCurrentBubble)
    }

    /// 移除指定弹框
    /// - Parameter tag: tag
    class func removeBubble(tag: Int) {
        Bubble.sharedInstance.removeBubble(tag: tag)
    }

    /// 移除指定弹框
    /// - Parameter priorityType: 优先级
    class func removeBubble(priorityType: BubblePriorityModel.BubblePriorityType) {
        Bubble.sharedInstance.removeBubble(priorityType: priorityType)
    }

    /// 绑定弹框与控制器（只会在这个控制器上显示）
    /// - Parameters:
    ///   - bubbleView: 弹框
    ///   - viewController: 控制器
    class func bindWithBubble(bubbleView: BubbleView, viewController: UIViewController) {
        bubbleView.dataModel.boundViewController = viewController
    }

    // MARK: Private Methods

    private func synchronized(_ lock: Any, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }

    private func addBubble(bubbleView: BubbleView,
                           priorityType: BubblePriorityModel.BubblePriorityType?,
                           priorityValue: Int?) -> BubblePriorityModel {
        let model = BubblePriorityModel.bubblePriorityModel(bubbleView: bubbleView,
                                                            priorityType: priorityType,
                                                            priorityValue: priorityValue)
        addBubble(priorityModel: model)
        return model
    }

    private func addBubble(priorityModel: BubblePriorityModel) {
        priorityModel.checkConfiguration()
        switch priorityModel.configuration.priorityType {
        case .priorityS: insertPriority(priorityArray: &prioritySArray, priorityModel: priorityModel)
        case .priorityA: insertPriority(priorityArray: &priorityAArray, priorityModel: priorityModel)
        case .priorityB: insertPriority(priorityArray: &priorityBArray, priorityModel: priorityModel)
        case .priorityC: insertPriority(priorityArray: &priorityCArray, priorityModel: priorityModel)
        }
    }

    private func addBubbles(priorityModels: [BubblePriorityModel]) {
        for model in priorityModels {
            addBubble(priorityModel: model)
        }
    }

    private func insertPriority(priorityArray: inout [BubblePriorityModel], priorityModel: BubblePriorityModel) {
        synchronized(self) {
            if let model = self.currentPriorityModel, model.configuration.endBubble {
                priorityModel.configuration.bubbleView.closeBubbleView(animation: false, stayInQueue: false)
                return
            }

            priorityModel.configuration.bubbleView.setUpMainRemoveFromQueueBlock {
                self.delete(priorityModel: priorityModel)
                self.currentPriorityModel = nil
                self.checkCurrentPriorityModel()
            }

            priorityModel.configuration.bubbleView.isHidden = true
            priorityModel.configuration.bubbleView.dataModel.existPriority = true

            if priorityArray.isEmpty {
                priorityArray.append(priorityModel)
            } else {
                for (index, existModel) in priorityArray.enumerated() {
                    if existModel.configuration.priorityValue < priorityModel.configuration.priorityValue {
                        priorityArray.insert(priorityModel, at: index)
                        break
                    } else if index == priorityArray.count - 1 {
                        priorityArray.append(priorityModel)
                        break
                    }
                }
            }

            if priorityModel.control.needWaitInQueue {
                priorityModel.startCountTimeInQueue()
            }
        }
    }

    private func checkCurrentPriorityModel() {
        synchronized(self) {
            if !self.prioritySArray.isEmpty {
                self.checkCurrentPriorityModel(priorityArray: &self.prioritySArray)
            } else if !self.priorityAArray.isEmpty {
                self.checkCurrentPriorityModel(priorityArray: &self.priorityAArray)
            } else if !self.priorityBArray.isEmpty {
                self.checkCurrentPriorityModel(priorityArray: &self.priorityBArray)
            } else if !self.priorityCArray.isEmpty {
                self.checkCurrentPriorityModel(priorityArray: &self.priorityCArray)
            }
        }
    }

    private func checkCurrentPriorityModel(priorityArray: inout [BubblePriorityModel]) {
        synchronized(self) {
            if let priorityModel = firstPriorityModel(priorityArray: &priorityArray), priorityModel !== currentPriorityModel {
                if let currentModel = currentPriorityModel {
                    currentModel.control.displayed = true

                    currentModel.configuration.bubbleView.closeBubbleView(stayInQueue: !currentModel.configuration.showOnce)

                    if currentModel.control.needWaitInQueue, !currentModel.configuration.showOnce {
                        currentModel.startCountTimeInQueue()
                    }

                    if currentModel.control.needWaitOnShow, !currentModel.configuration.showOnce {
                        currentModel.stopCountTimeOnShow()
                    }
                }

                if priorityModel.control.needWaitInQueue {
                    priorityModel.stopCountTimeInQueue()
                }

                if priorityModel.control.needWaitOnShow {
                    priorityModel.startCountTimeOnShow()

                    priorityModel.control.timeOnShowBlock = { (_ bubbleView: BubbleView?) in
                        if let view = bubbleView {
                            view.closeBubbleView(animation: true, stayInQueue: false)
                        }
                    }
                }

                deleteNotExistPriority()
                priorityModel.configuration.bubbleView.showBubbleView()
                currentPriorityModel = priorityModel

                if priorityModel.configuration.endBubble {
                    removeAllBubble(exceptCurrentBubble: true)
                }
            }
        }
    }

    private func firstPriorityModel(priorityArray: inout [BubblePriorityModel]) -> BubblePriorityModel? {
        if !priorityArray.isEmpty, let model = priorityArray.first {
            var passed = true
            if let bound = model.configuration.bubbleView.dataModel.boundViewController, let current = UIWindow().b_currentViewController {
                passed = bound == current
            }

            if (model.control.needWaitInQueue && model.control.overTimeInQueue) || !passed {
                priorityArray.removeFirst()
                return firstPriorityModel(priorityArray: &priorityArray)
            } else {
                return model
            }
        } else {
            return nil
        }
    }

    private func delete(priorityModel: BubblePriorityModel) {
        synchronized(self) {
            self.prioritySArray.removeAll(where: { $0 === priorityModel })
            self.priorityAArray.removeAll(where: { $0 === priorityModel })
            self.priorityBArray.removeAll(where: { $0 === priorityModel })
            self.priorityCArray.removeAll(where: { $0 === priorityModel })
        }
    }

    private func deleteNotExistPriority() {
        if let view = BubbleView.keyView(), let bubbleView = view as? BubbleView {
            if !bubbleView.dataModel.existPriority {
                bubbleView.closeBubbleView()
            }
        }
    }

    private func removeAllBubble() {
        removeAllBubble(exceptCurrentBubble: false)
    }

    private func removeAllBubble(exceptCurrentBubble: Bool) {
        synchronized(self) {
            self.deleteNotExistPriority()

            self.removeAllBubble(priorityArray: &self.prioritySArray, exceptCurrentBubble: exceptCurrentBubble)
            self.removeAllBubble(priorityArray: &self.priorityAArray, exceptCurrentBubble: exceptCurrentBubble)
            self.removeAllBubble(priorityArray: &self.priorityBArray, exceptCurrentBubble: exceptCurrentBubble)
            self.removeAllBubble(priorityArray: &self.priorityCArray, exceptCurrentBubble: exceptCurrentBubble)

            if !exceptCurrentBubble {
                self.currentPriorityModel = nil
            }
        }
    }

    private func removeAllBubble(priorityArray: inout [BubblePriorityModel], exceptCurrentBubble: Bool) {
        let needRemoves: [BubblePriorityModel] = priorityArray
        priorityArray.removeAll()

        var current: BubblePriorityModel?
        for model in needRemoves {
            if !exceptCurrentBubble || currentPriorityModel !== model {
                model.configuration.bubbleView.closeBubbleView(animation: false, stayInQueue: false)
            } else {
                current = model
            }
        }

        if let currentModel = current {
            currentPriorityModel = current
            priorityArray.append(currentModel)
        }
    }

    private func removeBubble(tag: Int) {
        synchronized(self) {
            self.removeBubble(tag: tag, priorityArray: &self.prioritySArray)
            self.removeBubble(tag: tag, priorityArray: &self.priorityAArray)
            self.removeBubble(tag: tag, priorityArray: &self.priorityBArray)
            self.removeBubble(tag: tag, priorityArray: &self.priorityCArray)

            if let model = self.currentPriorityModel, model.configuration.bubbleView.tag == tag {
                self.currentPriorityModel = nil
            }
        }
    }

    private func removeBubble(tag: Int, priorityArray: inout [BubblePriorityModel]) {
        synchronized(self) {
            var needRemoves: [BubblePriorityModel] = []
            for model in priorityArray where model.configuration.bubbleView.tag == tag {
                needRemoves.append(model)
            }

            priorityArray.removeAll(where: { $0.configuration.bubbleView.tag == tag })
        }
    }

    private func removeBubble(priorityType: BubblePriorityModel.BubblePriorityType) {
        synchronized(self) {
            switch priorityType {
            case .priorityS: removeBubble(priorityArray: &prioritySArray)
            case .priorityA: removeBubble(priorityArray: &priorityAArray)
            case .priorityB: removeBubble(priorityArray: &priorityBArray)
            case .priorityC: removeBubble(priorityArray: &priorityCArray)
            }

            if self.currentPriorityModel?.configuration.priorityType == priorityType {
                self.currentPriorityModel = nil
            }
        }
    }

    private func removeBubble(priorityArray: inout [BubblePriorityModel]) {
        synchronized(self) {
            let needRemoves: [BubblePriorityModel] = priorityArray
            priorityArray.removeAll()

            for model in needRemoves {
                model.configuration.bubbleView.closeBubbleView(animation: false, stayInQueue: false)
            }
        }
    }
}
