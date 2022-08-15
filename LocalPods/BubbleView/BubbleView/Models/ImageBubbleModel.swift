//
//  ImageBubbleModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/21.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class ImageBubbleModel: BasicBubbleModel {
    var imageFitWidth: Bool = true // 图片宽度适应

    var imageWidth: CGFloat = 0.0 // 图片 width

    var imageHeight: CGFloat = 0.0 // 图片 Height

    var image: UIImage? // 图片

    var imageBackColor: String = "" // 背景颜色

    var imageUrl: String = "" // 网络图片 Url

    var contentMode: UIView.ContentMode = .scaleToFill // 图片填充样式

    var placeholder: UIImage? // 占位图

    var errorImage: UIImage? // 加载失败图

    var imageEdgeInsets: UIEdgeInsets = .zero // 图片四周边距
}
