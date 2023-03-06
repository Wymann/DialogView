//
//  UIWindow+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/1/13.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base == UIApplication {
    var keyWindow: UIWindow? {
        guard let window = UIApplication.shared.windows.filter(\.isKeyWindow).last else {
            return UIApplication.shared.keyWindow
        }
        return window
//        if #available(iOS 13.0, *) {
//            return UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundInactive }
//                .first(where: { $0 is UIWindowScene })
//                .flatMap { $0 as? UIWindowScene }?.windows
//                .first(where: \.isKeyWindow) ?? UIWindow()
//        } else {
//            return UIApplication.shared.keyWindow
//        }
    }
}

extension EagleLabKit where Base == UIWindow {
    var rootViewController: UIViewController? {
        return UIApplication.shared.elk.keyWindow?.rootViewController
    }

    var currentViewController: UIViewController? {
        func findViewController(_ viewController: UIViewController?) -> UIViewController? {
            guard let viewController = viewController else { return viewController }
            if viewController.presentedViewController != nil {
                return findViewController(viewController.presentedViewController)
            } else if let navigationController = viewController as? UINavigationController {
                return findViewController(navigationController.viewControllers.last)
            } else if let tabBarController = viewController as? UITabBarController {
                return findViewController(tabBarController.selectedViewController)
            } else if let pageViewController = viewController as? UIPageViewController {
                return findViewController(pageViewController.viewControllers?.last)
            } else if viewController.children.isEmpty {
                return findViewController(viewController.children.last)
            }

            return viewController
        }

        return findViewController(rootViewController)
    }
}
