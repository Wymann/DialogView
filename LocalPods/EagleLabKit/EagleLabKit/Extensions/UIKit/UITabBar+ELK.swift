//
//  UITabBar+ELK.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/9/22.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UITabBar {
    func showBadgeOnItemIndex(index: Int) {
        guard let itemsCount = base.items?.count else { return }

        base.elk.removeBadgeOnItemIndex(index: index)

        let badgeView = UIView()
        badgeView.tag = 888 + index
        badgeView.layer.cornerRadius = 5.0
        if AppConfig.default.odmApp {
            badgeView.backgroundColor = UIColor(hexString: "#FF4040")
        } else {
            badgeView.backgroundColor = UIColor.red
        }
        let tabFrame = base.frame
        let percentX = (Double(index) + 0.6) / Double(itemsCount)
        let badgeViewX = ceilf(Float(percentX * tabFrame.size.width))
        let badgeViewY = ceilf(0.1 * Float(tabFrame.size.height))

        badgeView.frame = CGRect(x: Double(badgeViewX), y: Double(badgeViewY), width: 10.0, height: 10.0)
        base.addSubview(badgeView)
    }

    func hideBadgeOnItemIndex(index: Int) {
        base.elk.removeBadgeOnItemIndex(index: index)
    }

    func removeBadgeOnItemIndex(index: Int) {
        for itemView in base.subviews where itemView.tag == 888 + index {
            itemView.removeFromSuperview()
        }
    }
}
