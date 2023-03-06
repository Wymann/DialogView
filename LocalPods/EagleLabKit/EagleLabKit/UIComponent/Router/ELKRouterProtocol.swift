//
//  ELKRouterProtocol.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

public protocol ELKRouterAllowed: UIViewController {
    /// 打开
    /// - Parameter completion: 打开完成回调
    func open(with completion: @escaping () -> Void)

    /// 关闭
    /// - Parameters completion: 关闭完成回调
    func close(with completion: @escaping () -> Void)
}

public protocol ELKRouterPluggable {
    associatedtype TypeName

    /// 是否可以打开
    /// - Parameter type: 类型
    /// - Returns: true or false
    func should(open type: TypeName) -> Bool

    /// 准备打开
    /// - Parameters:
    ///   - type: 类型
    ///   - completion: 准备完成回调 (无论结果如何必须回调)
    func prepare(open type: TypeName, completion: @escaping (Bool) -> Void)

    /// 即将打开
    /// - Parameters:
    ///   - type: 类型
    ///   - controller: 视图控制器
    func will(open type: TypeName, controller: ELKRouterAllowed)

    /// 已经打开
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - controller: 视图控制器
    func did(open type: TypeName, controller: ELKRouterAllowed)
}

public protocol ELKRouterTypeAllowed: CaseIterable {
    /// 模板，用于注册 例如：xxx://open/<path:_>
    var pattern: String { get }

    /// 获取 ELKRouterAllowed 协议的控制器
    /// - Parameters:
    ///   - url: url
    ///   - values: 参数值
    /// - Returns: ELKRouterAllowed 如果返回为空则会调用下面打开处理方法
    func controller(url: URLConvertible, values: [String: Any]) -> ELKRouterAllowed?

    /// 打开处理 (当无控制器时执行)
    /// - Parameters:
    ///   - url: url
    ///   - values: 参数值
    ///   - completion: 处理完成结果回调 *必须调用
    func handle(url: URLConvertible, values: [String: Any], completion: @escaping (Bool) -> Void)
}

public extension String {
    func append(_ params: [String: String]) -> String {
        return append(self, params)
    }

    func append(_ url: String, _ params: [String: String]) -> String {
        guard var components = URLComponents(string: url) else {
            return url
        }

        let query = components.percentEncodedQuery ?? ""
        let temp = params.compactMap {
            guard !$0.isEmpty, !$1.isEmpty else { return nil }
            guard Foundation.URL(string: $1) != nil else {
                let encoded = $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $1
                return "\($0)=\(encoded)"
            }

            let string = "?!@#$^&%*+,:;='\"`<>()[]{}/\\| "
            let character = CharacterSet(charactersIn: string).inverted
            let encoded = $1.addingPercentEncoding(withAllowedCharacters: character) ?? $1
            return "\($0)=\(encoded)"
        }.joined(separator: "&")
        components.percentEncodedQuery = query.isEmpty ? temp : query + "&" + temp
        return components.url?.absoluteString ?? url
    }
}

public extension URL {
    func append(_ params: [String: String]) -> String {
        return absoluteString.append(params)
    }
}

public extension ELKRouterAllowed {
    func open(with completion: @escaping () -> Void = { }) {
        guard let controller = UIViewController.topMost else {
            return
        }

        if let navigation = controller as? UINavigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            navigation.pushViewController(self, animated: true)
            CATransaction.commit()

        } else if let navigation = controller.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            navigation.pushViewController(self, animated: true)
            CATransaction.commit()

        } else {
            let navigation = UINavigationController(rootViewController: self)
            controller.present(navigation, animated: true, completion: completion)
        }
    }

    func close(with completion: @escaping () -> Void = { }) {
        guard
            let navigation = navigationController,
            navigation.viewControllers.first != self else {
            let presenting = presentingViewController ?? self
            presenting.dismiss(animated: true, completion: completion)
            return
        }
        guard presentedViewController == nil else {
            dismiss(animated: true) { [weak self] in self?.close(with: completion) }
            return
        }

        func parents(_ controller: UIViewController) -> [UIViewController] {
            guard let parent = controller.parent else {
                return [controller]
            }
            return [controller] + parents(parent)
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        if let top = navigation.topViewController, parents(self).contains(top) {
            navigation.popViewController(animated: true)

        } else {
            let temp = navigation.viewControllers.filter { !parents(self).contains($0) }
            navigation.setViewControllers(temp, animated: true)
        }
        CATransaction.commit()
    }
}
