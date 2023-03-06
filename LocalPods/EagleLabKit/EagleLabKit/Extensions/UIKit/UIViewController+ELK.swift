//
//  UIViewController+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/1/19.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UIViewController {
    /// 状态栏高度
    var statusBarHeight: CGFloat {
        return base.navigationController?.navigationBar.frame.minY ?? UIScreen.main.elk.statusBarHeight
    }

    /// 导航栏 frame
    var navigationBarFrame: CGRect {
        return base.navigationController?.navigationBar.frame ?? .zero
    }

    /// 导航栏高度
    var navigationBarHeight: CGFloat {
        return navigationBarFrame.height
    }

    /// 导航栏最大 Y（statusBar 的高度 + navigationBar 的高度）
    var navigationBarMaxY: CGFloat {
        return navigationBarFrame.maxY
    }

    /// 导航栏可视区域大小（包括 statusBar 区域）
    var navigationBarVisualHeight: CGFloat {
        return navigationBarMaxY
    }
}
