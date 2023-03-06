//
//  ELKRouterProvider.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit
import URLNavigator

public typealias URLConvertible = URLNavigator.URLConvertible

public class ELKRouterProvider<T: ELKRouterTypeAllowed> {
    typealias ViewControllerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> ELKRouterAllowed?

    private let navigator: Navigator
    private let plugins: [ELKRouterPlugin<T>]

    public init(navigator: Navigator = Navigator(), _ plugins: [ELKRouterPlugin<T>]) {
        self.navigator = navigator
        self.plugins = plugins

        // 注册处理
        T.allCases.forEach { registers($0) }
    }
}

public extension ELKRouterProvider {
    /// open
    /// - Parameters:
    ///   - url: url
    /// - Returns: true or false
    @discardableResult
    func open(_ url: URLConvertible) -> Bool {
        return navigator.open(url, context: nil)
    }

    /// push
    /// - Parameters:
    ///   - url: url
    /// - Returns: true or false
    @discardableResult
    func push(_ url: URLConvertible) -> ELKRouterAllowed? {
//        let viewController = navigator.pushURL(url,
//                                               context: nil,
//                                               animated: true)
        let viewController = navigator.push(url)
        return viewController as? ELKRouterAllowed
    }

    /// present
    /// - Parameters:
    ///   - url: url
    /// - Returns: true or false
    @discardableResult
    func present(_ url: URLConvertible) -> ELKRouterAllowed? {
        let viewController = navigator.present(url,
                                               context: nil,
                                               wrap: UINavigationController.self,
                                               animated: true,
                                               completion: nil)
        return viewController as? ELKRouterAllowed
    }

    /// 获取视图控制器
    /// - Parameters:
    ///   - url: url
    /// - Returns: 视图控制器
    func viewController(_ url: URLConvertible, _ context: Any? = nil) -> ELKRouterAllowed? {
        return navigator.viewController(for: url, context: context) as? ELKRouterAllowed
    }
}

extension ELKRouterProvider {
    private func handle(_ url: T, _ factory: @escaping URLOpenHandlerFactory) {
        navigator.handle(url.pattern) { url, values, context -> Bool in
            return factory(url, values, context)
        }
    }

    private func register(_ url: T, _ factory: @escaping ViewControllerFactory) {
        navigator.register(url.pattern) { url, values, context -> UIViewController? in
            return factory(url, values, context)
        }
    }
}

extension ELKRouterProvider {
    private func registers(_ type: T) {
        register(type) { url, values, _ -> ELKRouterAllowed? in
            return type.controller(url: url, values: values)
        }

        handle(type) { [weak self] url, values, context -> Bool in
            guard let self = self else { return false }
            let context = context as? ELKRouterContext

            return self.handlePlugins(type,
                                      viewController: nil,
                                      context: context,
                                      url: url,
                                      values: values)
        }
    }

    private func handlePlugins(_ type: T,
                               viewController: ELKRouterAllowed?,
                               context: ELKRouterContext?,
                               url: URLConvertible,
                               values: [String: Any]) -> Bool {
        let page = (viewController != nil) ? viewController : self.viewController(url, context)
        if plugins.isEmpty {
            if let controller = page {
                controller.open {
                    context?.callback(true)
                }

            } else {
                type.handle(url: url, values: values) { result in
                    context?.callback(result)
                }
            }
        } else {
            guard plugins.contains(where: { $0.should(open: type) }) else { return false }
            var result = true
            let total = plugins.count
            var count = 0
            let group = DispatchGroup()
            plugins.forEach { pre in
                group.enter()
                pre.prepare(open: type) {
                    // 防止插件多次回调
                    defer { count += 1 }
                    guard count < total else { return }

                    result = $0 ? result : false
                    group.leave()
                }
            }

            group.notify(queue: .main) { [weak self] in
                guard let self = self else {
                    context?.callback(false)
                    return
                }
                guard result else {
                    context?.callback(false)
                    return
                }

                if let controller = page {
                    self.plugins.forEach {
                        $0.will(open: type, controller: controller)
                    }

                    controller.open { [weak self] in
                        guard let self = self else { return }
                        self.plugins.forEach {
                            $0.did(open: type, controller: controller)
                        }
                        context?.callback(true)
                    }

                } else {
                    type.handle(url: url, values: values) { result in
                        context?.callback(result)
                    }
                }
            }
        }
        return true
    }
}
