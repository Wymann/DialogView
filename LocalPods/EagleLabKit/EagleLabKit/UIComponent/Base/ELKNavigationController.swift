//
//  ELKNavigationController.swift
//  TCLHome
//
//  Created by lidan on 2022/1/11.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

class ELKNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
