//
//  Bubble+Sheet.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/15.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

extension Bubble {
    static func showSheet(models: [SheetModel],
                          configuration: SheetConfiguration = SheetConfiguration(),
                          itemClickBlock: BubbleSheet.BubbleSheetItemClick? = nil,
                          buttonClickBlock: BubbleSheet.BubbleSheetButtonClick? = nil) {
        let sheetWidth = BubbleSheet.sheetWidth()
        let sheetHeight = BubbleSheet.bubbleSheetHeight(models: models,
                                                        configuration: configuration,
                                                        sheetWidth: sheetWidth)
        let sheetFrame = CGRect(x: 0, y: 0, width: sheetWidth, height: sheetHeight)
        let sheet = BubbleSheet(frame: sheetFrame,
                                models: models,
                                configuration: configuration,
                                itemClickBlock: itemClickBlock,
                                buttonClickBlock: buttonClickBlock)

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: sheetWidth, height: sheetHeight + 40.0))
        customView.addSubview(sheet)

        let bubbleView = BubbleView()
        let bubbleConfig = BubbleViewConfig(animation: .showFromBottom, position: .stayBottom)
        bubbleView.configBubbleViewByCustomSize(customView: customView,
                                                customViewSize: customView.bounds.size,
                                                configuration: bubbleConfig)
        Bubble.addBubble(bubbleView: bubbleView)

        sheet.bubbleView = bubbleView
    }
}
