//
//  SelectorBubbleModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/17.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

/// 选择器弹窗配置
class SelectorPreference {
    var selectedTitleColor: String = "#2D3132" // 选中时候标题颜色
    var unselectedTitleColor: String = "#2D3132" // 非选中时候标题颜色
    var selectedSubtitleColor: String = "#2D313266" // 选中时候副标题颜色
    var unselectedSubtitleColor: String = "#2D313266" // 非选中时候副标题颜色
    var disabledColor: String = "#2D31321A" // 无法选中时候所有标题颜色
    var maxSelectNum: Int = 1 // 能选择的最大个数（默认为1）

    /// 是否点击即选中，并且直接结果回调
    /// 只在maxSelectNum为1的情况下起作用
    /// 为YES且maxSelectNum为1的时候右边显示的是箭头，否则显示的是选中非选中的圆点
    /// 默认为YES
    var resultFromItemTap: Bool = true

    var maxShownItemNum: Int = 8 // 一页能显示的最多的item，超过则需要上下滑动才能显示(默认为8)
    var maxSubtitleLines: Int = 3 // 副标题能显示的最多的行数(默认为3)
}

class SelectorBubbleItem {
    var title: String = "" // 标题
    var subtitle: String = "" // 副标题
    var selected: Bool = false // 是否选中状态
    var enabled: Bool = true // 是否可以被选中（NO的话置灰选项）
    var preference: SelectorPreference = .init() // 偏好配置

    class func createItem(title: String, subtitle: String, selected: Bool, enabled: Bool) -> SelectorBubbleItem {
        let item = SelectorBubbleItem()
        item.title = title
        item.subtitle = subtitle
        item.selected = selected
        item.enabled = enabled
        return item
    }
}

class SelectorBubbleModel: BasicBubbleModel {
    // 偏好配置
    var preference: SelectorPreference = .init() {
        didSet {
            setupSelectorBubbleItemPreference()
        }
    }

    // 数据集合
    var items: [SelectorBubbleItem] = [] {
        didSet {
            if items.first?.preference != nil {
                setupSelectorBubbleItemPreference()
            }
        }
    }

    private func setupSelectorBubbleItemPreference() {
        for item: SelectorBubbleItem in items {
            item.preference = preference
        }
    }
}
