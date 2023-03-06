//
//  Bubble+Share.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/10/9.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension Bubble {
    static func showShare(models: [ShareModel],
                          configuration: ShareConfiguration = .default,
                          itemClickBlock: BubbleShare.BubbleShareItemClick? = nil,
                          buttonClickBlock: BubbleShare.BubbleShareButtonClick? = nil) {
        let shareWidth = BubbleShare.shareWidth()
        let shareHeight = BubbleShare.bubbleShareHeight(models: models,
                                                        configuration: configuration,
                                                        shareWidth: shareWidth)
        let shareFrame = CGRect(x: 0, y: 0, width: shareWidth, height: shareHeight)
        let share = BubbleShare(frame: shareFrame,
                                models: models,
                                configuration: configuration,
                                itemClickBlock: itemClickBlock,
                                buttonClickBlock: buttonClickBlock)

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: shareWidth, height: shareHeight + 40.0))
        customView.addSubview(share)

        let bubbleView = BubbleView()
        let bubbleConfig = BubbleViewConfig(animation: .showFromBottom, position: .stayBottom, bounce: false)
        bubbleView.configBubbleViewByCustomSize(customView: customView,
                                                customViewSize: customView.bounds.size,
                                                configuration: bubbleConfig)
        Bubble.addBubble(bubbleView: bubbleView)

        share.bubbleView = bubbleView
    }
}
