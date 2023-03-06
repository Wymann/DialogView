//
//  ImageBubbleElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/22.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

class ImageBubbleElement: BasicBubbleElement {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func setUpDetailBubbleElement() {
        super.setUpDetailBubbleElement()
        if let imageModel = model as? ImageBubbleModel {
            layoutImageElement(imageModel: imageModel)
        }
    }

    private func layoutImageElement(imageModel: ImageBubbleModel) {
        if frame.height > 0 {
            addSubview(imageView)
            imageView.contentMode = imageModel.contentMode

            if imageModel.imageFitWidth {
                let imageX: CGFloat = imageModel.imageEdgeInsets.left
                let imageY: CGFloat = imageModel.imageEdgeInsets.top
                let imageW: CGFloat = frame.width - imageModel.imageEdgeInsets.left - imageModel.imageEdgeInsets.right
                let imageH: CGFloat = frame.height - imageModel.imageEdgeInsets.top - imageModel.imageEdgeInsets.bottom
                imageView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
            } else {
                let imageH: CGFloat = frame.height - imageModel.imageEdgeInsets.top - imageModel.imageEdgeInsets.bottom
                let imageW: CGFloat = imageModel.imageHeight > 0 ? imageModel.imageWidth * imageH / imageModel.imageHeight : 0.0
                let imageX: CGFloat = (frame.width - imageW) / 2
                let imageY: CGFloat = imageModel.imageEdgeInsets.top
                imageView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
            }

            if imageModel.image != nil {
                imageView.image = imageModel.image
                if !imageModel.imageBackColor.isEmpty {
                    imageView.backgroundColor = UIColor(hexString: imageModel.imageBackColor)
                }
            } else if let url = URL(string: imageModel.imageUrl) {
                let bubbleImageCache = ImageCache(name: "BubbleImageCache")
                let options: KingfisherOptionsInfo = [.targetCache(bubbleImageCache), .transition(ImageTransition.fade(1))]

                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: url, placeholder: imageModel.placeholder, options: options, progressBlock: nil) { result in
                    switch result {
                    case .success:
                        if !imageModel.imageBackColor.isEmpty {
                            self.imageView.backgroundColor = UIColor(hexString: imageModel.imageBackColor)
                        }
                    case .failure:
                        if imageModel.errorImage != nil {
                            self.imageView.image = imageModel.errorImage
                        }
                    }
                }
            }
        }
    }

    override class func elementHeight(model: BasicBubbleModel, elementWidth: CGFloat) -> CGFloat {
        if let imageModel = model as? ImageBubbleModel {
            if imageModel.imageFitWidth {
                var imageWidth: CGFloat = 0.0
                var imageHeight: CGFloat = 0.0

                if let image = imageModel.image {
                    imageWidth = image.size.width
                    imageHeight = image.size.height
                } else if !imageModel.imageUrl.isEmpty {
                    imageWidth = imageModel.imageWidth
                    imageHeight = imageModel.imageHeight
                }

                let width: CGFloat = elementWidth - imageModel.imageEdgeInsets.left - imageModel.imageEdgeInsets.right
                let height: CGFloat = imageWidth > 0 ? imageHeight * width / imageWidth : 0

                return height + imageModel.imageEdgeInsets.top + imageModel.imageEdgeInsets.bottom
            } else {
                return imageModel.imageHeight + imageModel.imageEdgeInsets.top + imageModel.imageEdgeInsets.bottom
            }
        } else {
            return 0.0
        }
    }
}
