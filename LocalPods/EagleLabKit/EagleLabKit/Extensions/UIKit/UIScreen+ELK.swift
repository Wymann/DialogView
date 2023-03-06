//
//  UIScreen+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/1/19.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base == UIScreen {
    var statusBarHeight: CGFloat {
        var height = UIApplication.shared.statusBarFrame.height
        if #available(iOS 13.0, *) {
            height = UIApplication.shared.elk.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? height
        }
        return height
    }

    var safeBottom: CGFloat {
        return UIApplication.shared.elk.keyWindow?.safeAreaInsets.bottom ?? 0
    }
}
