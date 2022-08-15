//
//  BubbleDemoModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

enum BubbleType {
    case common
    case specialColors
    case image
    case input
    case customView
    case sheet
}

enum BubbleSubType {
    case commonEnableSideTap
    case commonDisableSideTap
    case commonVerticalButtons

    case specialColorsCommon
    case specialColorsAttributed

    case localImage
    case netImage

    case customViewOnlyHeight
    case customViewOnlySize
    case customViewHeightAndPosition
    case customViewSizeAndPosition

    case inputTextField
    case inputTextFieldLimit
    case inputTextView

    case sheetNoneSelect
    case sheetSingleSelect1
    case sheetSingleSelect2
    case sheetMultipleSelect
}

class BubbleDemoModel {
    let cellHeight: CGFloat = 56.0

    var type: BubbleType
    var subType: BubbleSubType

    var title: String
    var subTitle: String

    init(type: BubbleType,
         subType: BubbleSubType,
         title: String,
         subTitle: String) {
        self.type = type
        self.subType = subType
        self.title = title
        self.subTitle = subTitle
    }
}

class BubbleDemoSection {
    var bubbleModels: [BubbleDemoModel]
    var title: String
    init(title: String,
         bubbleModels: [BubbleDemoModel]) {
        self.title = title
        self.bubbleModels = bubbleModels
    }
}

extension BubbleDemoModel {
    static func createDemoData() -> [BubbleDemoSection] {
        let commonSection = BubbleDemoSection(title: "Common: 普通弹框", bubbleModels: commonSection())

        let specialColorsSection = BubbleDemoSection(title: "Special colors: 特殊颜色弹框", bubbleModels: specialColorsSection())

        let imageSection = BubbleDemoSection(title: "Image: 图片弹框", bubbleModels: imageSection())

        let customViewSection = BubbleDemoSection(title: "Custom view: 自定义视图弹框", bubbleModels: customViewSection())

        let inputSection = BubbleDemoSection(title: "Input: 输入框弹框", bubbleModels: inputSection())

        let sheetSection = BubbleDemoSection(title: "Sheet: 只能从底部弹出", bubbleModels: sheetSection())

        return [commonSection, specialColorsSection, imageSection, customViewSection, inputSection, sheetSection]
    }

    private static func commonSection() -> [BubbleDemoModel] {
        let common1 = BubbleDemoModel(type: .common,
                                      subType: .commonEnableSideTap,
                                      title: "普通弹框1",
                                      subTitle: "只有标题和内容，点击空白处可消失")
        let common2 = BubbleDemoModel(type: .common,
                                      subType: .commonDisableSideTap,
                                      title: "普通弹框2",
                                      subTitle: "只有标题和内容，点击空白处不消失")
        let common3 = BubbleDemoModel(type: .common,
                                      subType: .commonVerticalButtons,
                                      title: "普通弹框3",
                                      subTitle: "按钮是垂直布局的")
        return [common1, common2, common3]
    }

    private static func specialColorsSection() -> [BubbleDemoModel] {
        let specialColors1 = BubbleDemoModel(type: .specialColors,
                                             subType: .specialColorsCommon,
                                             title: "特殊颜色弹框1",
                                             subTitle: "副标题是纯文本")
        let specialColors2 = BubbleDemoModel(type: .specialColors,
                                             subType: .specialColorsAttributed,
                                             title: "特殊颜色弹框2",
                                             subTitle: "副标题是富文本")
        return [specialColors1, specialColors2]
    }

    private static func imageSection() -> [BubbleDemoModel] {
        let image1 = BubbleDemoModel(type: .image, subType: .localImage, title: "本地图片弹框", subTitle: "图片 position 和 sizeType 在下拉框中选择")
        let image2 = BubbleDemoModel(type: .image, subType: .netImage, title: "网络图片弹框", subTitle: "图片 position 和 sizeType 在下拉框中选择")
        return [image1, image2]
    }

    private static func customViewSection() -> [BubbleDemoModel] {
        let customView1 = BubbleDemoModel(type: .customView,
                                          subType: .customViewOnlyHeight,
                                          title: "自定义试图弹窗1",
                                          subTitle: "自定义视图高度（宽度按照规范）")
        let customView2 = BubbleDemoModel(type: .customView,
                                          subType: .customViewOnlySize,
                                          title: "自定义试图弹窗2",
                                          subTitle: "自定义视图 Size")
        let customView3 = BubbleDemoModel(type: .customView,
                                          subType: .customViewHeightAndPosition,
                                          title: "自定义试图弹窗3",
                                          subTitle: "自定义视图高度，同时自定义弹出位置以及动画")
        let customView4 = BubbleDemoModel(type: .customView,
                                          subType: .customViewSizeAndPosition,
                                          title: "自定义试图弹窗4",
                                          subTitle: "自定义视图 Size，同时自定义弹出位置以及动画")
        return [customView1, customView2, customView3, customView4]
    }

    private static func inputSection() -> [BubbleDemoModel] {
        let input1 = BubbleDemoModel(type: .input,
                                     subType: .inputTextField,
                                     title: "输入框弹框1",
                                     subTitle: "UITextField 输入框。不能包含“我”这个字")
        let input2 = BubbleDemoModel(type: .input,
                                     subType: .inputTextFieldLimit,
                                     title: "输入框弹框2",
                                     subTitle: "UITextField 输入框。不能输入超过10个字。并且设置 UITextField 其它属性。")
        let input3 = BubbleDemoModel(type: .input,
                                     subType: .inputTextView,
                                     title: "输入框弹框3",
                                     subTitle: "UITextView输入框。限制字数210个。")
        return [input1, input2, input3]
    }

    private static func sheetSection() -> [BubbleDemoModel] {
        let sheet1 = BubbleDemoModel(type: .sheet,
                                     subType: .sheetNoneSelect,
                                     title: "Sheet 弹框1",
                                     subTitle: "无选项")
        let sheet2 = BubbleDemoModel(type: .sheet,
                                     subType: .sheetSingleSelect1,
                                     title: "Sheet 弹框2",
                                     subTitle: "单选（点击选项后直接关闭）")
        let sheet3 = BubbleDemoModel(type: .sheet,
                                     subType: .sheetSingleSelect2,
                                     title: "Sheet 弹框3",
                                     subTitle: "单选（点击“确定”按钮后才关闭）")
        let sheet4 = BubbleDemoModel(type: .sheet,
                                     subType: .sheetMultipleSelect,
                                     title: "Sheet 弹框4",
                                     subTitle: "多选（最多三个）")
        return [sheet1, sheet2, sheet3, sheet4]
    }

    static func sheetModels(_ existSubtitle: Bool, selectedIndexes: [Int] = [], number: Int = 8) -> [SheetModel] {
        var models: [SheetModel] = []
        for index in 1 ..< number {
            let model = SheetModel(title: "选项\(index)", subtitle: existSubtitle ? "描述\(index)" : "")
            if selectedIndexes.contains(index) {
                model.selected = true
            }
            models.append(model)
        }
        return models
    }
//
//    private static func () -> [BubbleDemoModel] {
//
//    }
}
