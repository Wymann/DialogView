//
//  UIView+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/1/13.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UIView {
    /// 不要使用 UIView() 或者 UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
    /// 比如使用上面的方式在 UITableView 的 (tableHeader/tableFooter)View 中就不准确
    static var empty: UIView {
        let nonzero = CGFloat.leastNonzeroMagnitude
        let view = UIView(frame: CGRect(x: nonzero, y: nonzero, width: nonzero, height: nonzero))
        view.backgroundColor = .clear
        return view
    }

    func withRectCorners(corners: UIRectCorner, cornerRadii: CGSize) {
        let bezierPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = base.bounds
        shapeLayer.path = bezierPath.cgPath
        base.layer.mask = shapeLayer
    }

    func withRectTopCornerRadius(cornerRadii: CGSize) {
        base.elk.withRectCorners(corners: [.topLeft, .topRight], cornerRadii: cornerRadii)
    }

    func withRectBottomCornerRadius(cornerRadii: CGSize) {
        base.elk.withRectCorners(corners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadii)
    }

    func withRectTopAndBottomCornerRadius(cornerRadii: CGSize) {
        base.elk.withRectCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: cornerRadii)
    }
}
