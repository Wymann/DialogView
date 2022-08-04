//
//  Dialog.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class Dialog: NSObject {
    private var prioritySArray: [DialogPriorityModel] = []
    private var priorityAArray: [DialogPriorityModel] = []
    private var priorityBArray: [DialogPriorityModel] = []
    private var priorityCArray: [DialogPriorityModel] = []
    private var currentPriorityModel: DialogPriorityModel?

    static let sharedInstance = Dialog()

    // MARK: Public Methods

    /// 添加一个弹框
    /// - Parameters:
    ///   - dialogView: 弹框
    ///   - priorityType: 优先级
    ///   - priorityValue: 优先值
    /// - Returns: DialogPriorityModel
    @discardableResult
    public class func addDialog(dialogView: DialogView,
                                priorityType: DialogPriorityModel.DialogPriorityType?,
                                priorityValue: Int?) -> DialogPriorityModel {
        let model = Dialog.sharedInstance.addDialog(dialogView: dialogView,
                                                    priorityType: priorityType,
                                                    priorityValue: priorityValue)
        Dialog.sharedInstance.checkCurrentPriorityModel()
        return model
    }

    /// 添加一个弹框（priorityType 为 DialogPriorityB， priorityValue 为0）
    /// - Parameter dialogView: 弹框
    /// - Returns: DialogPriorityModel
    @discardableResult
    public class func addDialog(dialogView: DialogView) -> DialogPriorityModel {
        let model = Dialog.sharedInstance.addDialog(dialogView: dialogView,
                                                    priorityType: .priorityB,
                                                    priorityValue: 0)
        Dialog.sharedInstance.checkCurrentPriorityModel()
        return model
    }

    /// 添加多个弹框（priorityType 为 DialogPriorityB， priorityValue 为0），依次弹出
    /// - Parameter dialogViews: 弹框集合
    /// - Returns: [DialogPriorityModel]
    @discardableResult
    public class func addDialogs(dialogViews: [DialogView]) -> [DialogPriorityModel] {
        var models: [DialogPriorityModel] = []

        for dialogView in dialogViews {
            let model = Dialog.sharedInstance.addDialog(dialogView: dialogView,
                                                        priorityType: .priorityB,
                                                        priorityValue: 0)
            models.append(model)
        }

        Dialog.sharedInstance.addDialogs(priorityModels: models)
        Dialog.sharedInstance.checkCurrentPriorityModel()
        return models
    }

    /// 添加多个弹框模型
    /// - Parameter priorityModels: 弹框模型集合
    public class func addDialogs(priorityModels: [DialogPriorityModel]) {
        Dialog.sharedInstance.addDialogs(priorityModels: priorityModels)
        Dialog.sharedInstance.checkCurrentPriorityModel()
    }

    /// 移除所有弹框
    public class func removeAllDialog() {
        Dialog.sharedInstance.removeAllDialog()
    }

    /// 移除所有弹框
    /// - Parameter exceptCurrentDialog: 是否除去当前正在显示的（true 的话当前显示的弹框不移除）
    public class func removeAllDialog(exceptCurrentDialog: Bool) {
        Dialog.sharedInstance.removeAllDialog(exceptCurrentDialog: exceptCurrentDialog)
    }

    /// 移除指定弹框
    /// - Parameter tag: tag
    public class func removeDialog(tag: Int) {
        Dialog.sharedInstance.removeDialog(tag: tag)
    }

    /// 移除指定弹框
    /// - Parameter priorityType: 优先级
    public class func removeDialog(priorityType: DialogPriorityModel.DialogPriorityType) {
        Dialog.sharedInstance.removeDialog(priorityType: priorityType)
    }

    /// 绑定弹框与控制器（只会在这个控制器上显示）
    /// - Parameters:
    ///   - dialogView: 弹框
    ///   - viewController: 控制器
    public class func bindWithDialog(dialogView: DialogView, viewController: UIViewController) {
        dialogView.dataModel.boundViewController = viewController
    }

    // MARK: Private Methods

    func synchronized(_ lock: Any, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }

    private func addDialog(dialogView: DialogView,
                           priorityType: DialogPriorityModel.DialogPriorityType?,
                           priorityValue: Int?) -> DialogPriorityModel {
        let model = DialogPriorityModel.dialogPriorityModel(dialogView: dialogView,
                                                            priorityType: priorityType,
                                                            priorityValue: priorityValue)
        addDialog(priorityModel: model)
        return model
    }

    private func addDialog(priorityModel: DialogPriorityModel) {
        priorityModel.checkConfiguration()
        switch priorityModel.configuration.priorityType {
        case .priorityS: insertPriority(priorityArray: &prioritySArray, priorityModel: priorityModel)
        case .priorityA: insertPriority(priorityArray: &priorityAArray, priorityModel: priorityModel)
        case .priorityB: insertPriority(priorityArray: &priorityBArray, priorityModel: priorityModel)
        case .priorityC: insertPriority(priorityArray: &priorityCArray, priorityModel: priorityModel)
        }
    }

    private func addDialogs(priorityModels: [DialogPriorityModel]) {
        for model in priorityModels {
            addDialog(priorityModel: model)
        }
    }

    private func insertPriority(priorityArray: inout [DialogPriorityModel], priorityModel: DialogPriorityModel) {
        synchronized(self) {
            if let model = self.currentPriorityModel, model.configuration.endDialog {
                priorityModel.configuration.dialogView.closeDialogView(animation: false, stayInQueue: false)
                return
            }

            priorityModel.configuration.dialogView.setUpMainRemoveFromQueueBlock {
                self.delete(priorityModel: priorityModel)
                self.currentPriorityModel = nil
                self.checkCurrentPriorityModel()
            }

            priorityModel.configuration.dialogView.isHidden = true
            priorityModel.configuration.dialogView.dataModel.existPriority = true

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

    private func checkCurrentPriorityModel(priorityArray: inout [DialogPriorityModel]) {
        synchronized(self) {
            if let priorityModel = firstPriorityModel(priorityArray: &priorityArray), priorityModel !== currentPriorityModel {
                if let currentModel = currentPriorityModel {
                    currentModel.control.displayed = true

                    currentModel.configuration.dialogView.closeDialogView(stayInQueue: !currentModel.configuration.showOnce)

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

                    priorityModel.control.timeOnShowBlock = { (_ dialogView: DialogView?) in
                        if let view = dialogView {
                            view.closeDialogView(animation: true, stayInQueue: false)
                        }
                    }
                }

                deleteNotExistPriority()
                priorityModel.configuration.dialogView.showDialogView()
                currentPriorityModel = priorityModel

                if priorityModel.configuration.endDialog {
                    removeAllDialog(exceptCurrentDialog: true)
                }
            }
        }
    }

    private func firstPriorityModel(priorityArray: inout [DialogPriorityModel]) -> DialogPriorityModel? {
        if !priorityArray.isEmpty, let model = priorityArray.first {
            var passed = true
            if let bound = model.configuration.dialogView.dataModel.boundViewController, let current = UIWindow().elk.currentViewController {
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

    private func delete(priorityModel: DialogPriorityModel) {
        synchronized(self) {
            self.prioritySArray.removeAll(where: { $0 === priorityModel })
            self.priorityAArray.removeAll(where: { $0 === priorityModel })
            self.priorityBArray.removeAll(where: { $0 === priorityModel })
            self.priorityCArray.removeAll(where: { $0 === priorityModel })
        }
    }

    private func deleteNotExistPriority() {
        if let view = DialogView.keyView(), let dialogView = view as? DialogView {
            if !dialogView.dataModel.existPriority {
                dialogView.closeDialogView()
            }
        }
    }

    private func removeAllDialog() {
        removeAllDialog(exceptCurrentDialog: false)
    }

    private func removeAllDialog(exceptCurrentDialog: Bool) {
        synchronized(self) {
            self.deleteNotExistPriority()

            self.removeAllDialog(priorityArray: &self.prioritySArray, exceptCurrentDialog: exceptCurrentDialog)
            self.removeAllDialog(priorityArray: &self.priorityAArray, exceptCurrentDialog: exceptCurrentDialog)
            self.removeAllDialog(priorityArray: &self.priorityBArray, exceptCurrentDialog: exceptCurrentDialog)
            self.removeAllDialog(priorityArray: &self.priorityCArray, exceptCurrentDialog: exceptCurrentDialog)

            if !exceptCurrentDialog {
                self.currentPriorityModel = nil
            }
        }
    }

    private func removeAllDialog(priorityArray: inout [DialogPriorityModel], exceptCurrentDialog: Bool) {
        let needRemoves: [DialogPriorityModel] = priorityArray
        priorityArray.removeAll()

        var current: DialogPriorityModel?
        for model in needRemoves {
            if !exceptCurrentDialog || currentPriorityModel !== model {
                model.configuration.dialogView.closeDialogView(animation: false, stayInQueue: false)
            } else {
                current = model
            }
        }

        if let currentModel = current {
            currentPriorityModel = current
            priorityArray.append(currentModel)
        }
    }

    private func removeDialog(tag: Int) {
        synchronized(self) {
            self.removeDialog(tag: tag, priorityArray: &self.prioritySArray)
            self.removeDialog(tag: tag, priorityArray: &self.priorityAArray)
            self.removeDialog(tag: tag, priorityArray: &self.priorityBArray)
            self.removeDialog(tag: tag, priorityArray: &self.priorityCArray)

            if let model = self.currentPriorityModel, model.configuration.dialogView.tag == tag {
                self.currentPriorityModel = nil
            }
        }
    }

    private func removeDialog(tag: Int, priorityArray: inout [DialogPriorityModel]) {
        synchronized(self) {
            var needRemoves: [DialogPriorityModel] = []
            for model in priorityArray where model.configuration.dialogView.tag == tag {
                needRemoves.append(model)
            }

            priorityArray.removeAll(where: { $0.configuration.dialogView.tag == tag })
        }
    }

    private func removeDialog(priorityType: DialogPriorityModel.DialogPriorityType) {
        synchronized(self) {
            switch priorityType {
            case .priorityS: removeDialog(priorityArray: &prioritySArray)
            case .priorityA: removeDialog(priorityArray: &priorityAArray)
            case .priorityB: removeDialog(priorityArray: &priorityBArray)
            case .priorityC: removeDialog(priorityArray: &priorityCArray)
            }

            if self.currentPriorityModel?.configuration.priorityType == priorityType {
                self.currentPriorityModel = nil
            }
        }
    }

    private func removeDialog(priorityArray: inout [DialogPriorityModel]) {
        synchronized(self) {
            let needRemoves: [DialogPriorityModel] = priorityArray
            priorityArray.removeAll()

            for model in needRemoves {
                model.configuration.dialogView.closeDialogView(animation: false, stayInQueue: false)
            }
        }
    }
}
