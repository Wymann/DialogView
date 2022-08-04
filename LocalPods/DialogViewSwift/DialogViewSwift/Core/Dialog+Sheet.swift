//
//  Dialog+Sheet.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/15.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

extension EagleLabKit where Base: Dialog {
    static func showSheet(models: [SheetModel],
                          configuration: SheetConfiguration = SheetConfiguration(),
                          itemClickBlock: DialogSheet.DialogSheetItemClick? = nil,
                          buttonClickBlock: DialogSheet.DialogSheetButtonClick? = nil) {
        let sheetWidth = DialogSheet.sheetWidth()
        let sheetHeight = DialogSheet.dialogSheetHeight(models: models,
                                                        configuration: configuration,
                                                        sheetWidth: sheetWidth)
        let sheetFrame = CGRect(x: 0, y: 0, width: sheetWidth, height: sheetHeight)
        let sheet = DialogSheet(frame: sheetFrame,
                                models: models,
                                configuration: configuration,
                                itemClickBlock: itemClickBlock,
                                buttonClickBlock: buttonClickBlock)

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: sheetWidth, height: sheetHeight + 40.0))
        customView.addSubview(sheet)

        let dialogView = DialogView()
        let dialogConfig = DialogViewConfig(animation: .showFromBottom, position: .stayBottom)
        dialogView.configDialogViewByCustomSize(customView: customView,
                                                customViewSize: customView.bounds.size,
                                                configuration: dialogConfig)
        Dialog.addDialog(dialogView: dialogView)

        sheet.dialogView = dialogView
    }
}
