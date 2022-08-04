//
//  DialogDemoModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

enum DialogType {
    case common
    case specialColors
    case image
    case input
    case customView
    case sheet
}

enum DialogSubType {
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

class DialogDemoModel {
    let cellHeight: CGFloat = 56.0

    var type: DialogType
    var subType: DialogSubType

    var title: String
    var subTitle: String

    init(type: DialogType,
         subType: DialogSubType,
         title: String,
         subTitle: String) {
        self.type = type
        self.subType = subType
        self.title = title
        self.subTitle = subTitle
    }
}

class DialogDemoSection {
    var dialogModels: [DialogDemoModel]
    var title: String
    init(title: String,
         dialogModels: [DialogDemoModel]) {
        self.title = title
        self.dialogModels = dialogModels
    }
}

extension DialogDemoModel {
    static func createDemoData() -> [DialogDemoSection] {
        let commonSection = DialogDemoSection(title: "Common: 普通弹框", dialogModels: commonSection())

        let specialColorsSection = DialogDemoSection(title: "Special colors: 特殊颜色弹框", dialogModels: specialColorsSection())

        let imageSection = DialogDemoSection(title: "Image: 图片弹框", dialogModels: imageSection())

        let customViewSection = DialogDemoSection(title: "Custom view: 自定义视图弹框", dialogModels: customViewSection())

        let inputSection = DialogDemoSection(title: "Input: 输入框弹框", dialogModels: inputSection())

        let sheetSection = DialogDemoSection(title: "Sheet: 只能从底部弹出", dialogModels: sheetSection())

        return [commonSection, specialColorsSection, imageSection, customViewSection, inputSection, sheetSection]
    }

    private static func commonSection() -> [DialogDemoModel] {
        let common1 = DialogDemoModel(type: .common,
                                      subType: .commonEnableSideTap,
                                      title: "普通弹框1",
                                      subTitle: "只有标题和内容，点击空白处可消失")
        let common2 = DialogDemoModel(type: .common,
                                      subType: .commonDisableSideTap,
                                      title: "普通弹框2",
                                      subTitle: "只有标题和内容，点击空白处不消失")
        let common3 = DialogDemoModel(type: .common,
                                      subType: .commonVerticalButtons,
                                      title: "普通弹框3",
                                      subTitle: "按钮是垂直布局的")
        return [common1, common2, common3]
    }

    private static func specialColorsSection() -> [DialogDemoModel] {
        let specialColors1 = DialogDemoModel(type: .specialColors,
                                             subType: .specialColorsCommon,
                                             title: "特殊颜色弹框1",
                                             subTitle: "副标题是纯文本")
        let specialColors2 = DialogDemoModel(type: .specialColors,
                                             subType: .specialColorsAttributed,
                                             title: "特殊颜色弹框2",
                                             subTitle: "副标题是富文本")
        return [specialColors1, specialColors2]
    }

    private static func imageSection() -> [DialogDemoModel] {
        let image1 = DialogDemoModel(type: .image, subType: .localImage, title: "本地图片弹框", subTitle: "图片 position 和 sizeType 在下拉框中选择")
        let image2 = DialogDemoModel(type: .image, subType: .netImage, title: "网络图片弹框", subTitle: "图片 position 和 sizeType 在下拉框中选择")
        return [image1, image2]
    }

    private static func customViewSection() -> [DialogDemoModel] {
        let customView1 = DialogDemoModel(type: .customView,
                                          subType: .customViewOnlyHeight,
                                          title: "自定义试图弹窗1",
                                          subTitle: "自定义视图高度（宽度按照规范）")
        let customView2 = DialogDemoModel(type: .customView,
                                          subType: .customViewOnlySize,
                                          title: "自定义试图弹窗2",
                                          subTitle: "自定义视图 Size")
        let customView3 = DialogDemoModel(type: .customView,
                                          subType: .customViewHeightAndPosition,
                                          title: "自定义试图弹窗3",
                                          subTitle: "自定义视图高度，同时自定义弹出位置以及动画")
        let customView4 = DialogDemoModel(type: .customView,
                                          subType: .customViewSizeAndPosition,
                                          title: "自定义试图弹窗4",
                                          subTitle: "自定义视图 Size，同时自定义弹出位置以及动画")
        return [customView1, customView2, customView3, customView4]
    }

    private static func inputSection() -> [DialogDemoModel] {
        let input1 = DialogDemoModel(type: .input,
                                     subType: .inputTextField,
                                     title: "输入框弹框1",
                                     subTitle: "UITextField 输入框。不能包含“我”这个字")
        let input2 = DialogDemoModel(type: .input,
                                     subType: .inputTextFieldLimit,
                                     title: "输入框弹框2",
                                     subTitle: "UITextField 输入框。不能输入超过10个字。并且设置 UITextField 其它属性。")
        let input3 = DialogDemoModel(type: .input,
                                     subType: .inputTextView,
                                     title: "输入框弹框3",
                                     subTitle: "UITextView输入框。限制字数210个。")
        return [input1, input2, input3]
    }

    private static func sheetSection() -> [DialogDemoModel] {
        let sheet1 = DialogDemoModel(type: .sheet,
                                     subType: .sheetNoneSelect,
                                     title: "Sheet 弹框1",
                                     subTitle: "无选项")
        let sheet2 = DialogDemoModel(type: .sheet,
                                     subType: .sheetSingleSelect1,
                                     title: "Sheet 弹框2",
                                     subTitle: "单选（点击选项后直接关闭）")
        let sheet3 = DialogDemoModel(type: .sheet,
                                     subType: .sheetSingleSelect2,
                                     title: "Sheet 弹框3",
                                     subTitle: "单选（点击“确定”按钮后才关闭）")
        let sheet4 = DialogDemoModel(type: .sheet,
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
//    private static func () -> [DialogDemoModel] {
//
//    }
}
