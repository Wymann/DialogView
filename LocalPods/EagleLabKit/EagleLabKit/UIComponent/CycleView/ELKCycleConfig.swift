//
//  ELKCycleConfig.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/6.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

enum ELKCycleViewStyle {
    case normal // 普通：item 跟 CycleView 大小一致，且无缩放动画
    case scaleUp // 放大特效：item 滑动到中间的时候会按比例放大
}

class ELKCycleConfig {
    /// 是否显示 PageControl
    var showPageControl: Bool = true

    /// 初始位置
    var initialIndex: Int? = 0

    /// 是否无限轮播
    var isInfinite: Bool = true

    /// 是否自动滚动
    var isAutomatic: Bool = true

    /// 自动滚动的时间间隔
    var timeInterval: Int = 3

    /// 滚动方向
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal

    /// 占位图
    var placeholderImage: UIImage?

    /// item 大小
    var itemSize: CGSize?

    /// 中间 item 的放大比例 必须 >= 1.0
    var itemZoomScale: CGFloat = 1.0

    /// item 间距
    var itemSpacing: CGFloat = 0.0

    init(style: ELKCycleViewStyle,
         cycleViewSize: CGSize,
         initialIndex: Int? = 0,
         isInfinite: Bool = true,
         isAutomatic: Bool = true) {
        self.initialIndex = initialIndex
        self.isInfinite = isInfinite
        self.isAutomatic = isAutomatic

        switch style {
        case .normal:
            itemZoomScale = 1.0
            itemSpacing = 0.0
            itemSize = cycleViewSize
        case .scaleUp:
            itemZoomScale = 1.2
            itemSpacing = 10.0
            itemSize = CGSize(width: cycleViewSize.width - 150, height: (cycleViewSize.width - 150) / 2.3333)
        }
    }
}
