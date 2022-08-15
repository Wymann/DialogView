//
//  UIViewController+Bubble.swift
//  BubbleView
//
//  Created by huaizhang.chen on 2022/8/15.
//

import UIKit

extension UIApplication {
    var b_keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap { $0 as? UIWindowScene }?.windows
                .first(where: \.isKeyWindow) ?? UIWindow()
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension  UIWindow {
    var b_rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    var b_currentViewController: UIViewController? {
        func b_findViewController(_ viewController: UIViewController?) -> UIViewController? {
            guard let viewController = viewController else { return viewController }
            if viewController.presentedViewController != nil {
                return b_findViewController(viewController.presentedViewController)
            } else if let navigationController = viewController as? UINavigationController {
                return b_findViewController(navigationController.viewControllers.last)
            } else if let tabBarController = viewController as? UITabBarController {
                return b_findViewController(tabBarController.selectedViewController)
            } else if let pageViewController = viewController as? UIPageViewController {
                return b_findViewController(pageViewController.viewControllers?.last)
            } else if viewController.children.isEmpty {
                return b_findViewController(viewController.children.last)
            }

            return viewController
        }

        return b_findViewController(rootViewController)
    }
}
