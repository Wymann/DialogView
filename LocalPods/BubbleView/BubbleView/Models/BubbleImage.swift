//
//  BubbleImage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

enum BubbleImageSize {
    case common // 普通类型（距离 BubbleView 边距为参照 BubblePattern）
    case large // 大图类型（距离 BubbleView 边距为0）
    case small // 小图类型（水平居中且宽为100的icon）
    case tiny // 微图类型（水平居中且宽为50的icon）
}

enum BubbleImagePosition {
    case middle // 图片在中间
    case top // 图片在顶部
}

enum BubbleImageStyle {
    case local // 本地图片
    case net // 网络图片
    case none // 无
}

struct BubbleImageConfiguration {
    var sizeType: BubbleImageSize = .common
    var customImageSize: CGSize = .zero // 自定义图片 Size
    var position: BubbleImagePosition = .middle
}

struct BubbleNetImage {
    var imageUrl: String = ""
    var placeholder: UIImage?
    var errorImage: UIImage?
    var imageSize: CGSize = .zero // 预设置网络图片的宽高（用于计算比例）

    // Image Configuration
    var configuration: BubbleImageConfiguration = .init()
}

struct BubbleLocalImage {
    // Local Image
    var image: UIImage

    // Image Configuration
    var configuration: BubbleImageConfiguration = .init()
}

struct BubbleImage {
    // Local Image
    var localImage: BubbleLocalImage?

    // Net Image
    var netImage: BubbleNetImage?

    init(localImage: BubbleLocalImage? = nil, netImage: BubbleNetImage? = nil) {
        self.localImage = localImage
        self.netImage = netImage
    }

    // 图片类型
    var style: BubbleImageStyle {
        if localImage != nil {
            return .local
        } else if let net = netImage, net.imageUrl.hasPrefix("http") {
            return .net
        } else {
            return .none
        }
    }

    // Image Configuration
    var configuration: BubbleImageConfiguration {
        if let local = localImage {
            return local.configuration
        } else if let net = netImage, net.imageUrl.hasPrefix("http") {
            return net.configuration
        } else {
            return BubbleImageConfiguration()
        }
    }
}
