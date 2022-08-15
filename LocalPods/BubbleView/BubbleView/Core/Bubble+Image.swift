//
//  Bubble+LocalImage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

// MARK: 自动显示弹框

extension Bubble {
    /// 显示图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（支持纯文本和富文本）
    ///   - image: 图片（支持本地图片和网络图片）
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    @discardableResult
    static func showBubble(title: String,
                           subtitle: BubbleSubtitle,
                           image: BubbleImage,
                           buttons: [String]?,
                           resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        let view = bubble(title: title,
                          subtitle: subtitle,
                          image: image,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Bubble.addBubble(bubbleView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension Bubble {
    /// 图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（支持纯文本和富文本）
    ///   - image: 图片（支持本地图片和网络图片）
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: BubbleView
    static func bubble(title: String,
                       subtitle: BubbleSubtitle,
                       image: BubbleImage,
                       buttons: [String]?,
                       resultBlock: BubbleView.BubbleViewResult?) -> BubbleView {
        if image.style != .none {
            var array: [BasicBubbleModel] = []

            let imageSize: CGSize = imageSize(image: image)
            let (imageFitWidth, realImageSize) = realImageSize(imageSize: imageSize, sizeType: image.configuration.sizeType)
            let imageModel: ImageBubbleModel = imageModel(imageFitWidth: imageFitWidth,
                                                          realImageSize: realImageSize,
                                                          image: image)

            if image.configuration.position == .top { array.append(imageModel) }

            var textModel: TextBubbleModel = .init()
            if !title.isEmpty {
                textModel = BubbleModelEditor.createTextBubbleModel(title: title, titleColor: "")
                array.append(textModel)
            }

            var textModel1: TextBubbleModel = .init()
            if !subtitle.subtitle.isEmpty {
                textModel1 = BubbleModelEditor.createTextBubbleModel(subtitle: subtitle.subtitle, subtitleColor: "")
                array.append(textModel1)
            } else if let attributedSubText = subtitle.attributedSubtitle, !attributedSubText.string.isEmpty {
                textModel1 = BubbleModelEditor.createTextBubbleModel(attributedSubtitle: attributedSubText, subtitleColor: "")
                array.append(textModel1)
            }

            if image.configuration.position == .middle { array.append(imageModel) }

            BubbleModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

            if let buttonsArray = buttons, !buttonsArray.isEmpty {
                let buttonsModel = BubbleModelEditor.createButtonsBubbleModel(buttons: buttonsArray)
                array.append(buttonsModel)
            }

            fixImageAndTextMargin(imageModel: imageModel,
                                  titleModel: textModel,
                                  subtitleModel: textModel1,
                                  sizeType: image.configuration.sizeType,
                                  position: image.configuration.position)

            let view = BubbleView()
            view.configBubbleView(bubbleModels: array)
            view.bubbleResult = resultBlock
            return view

        } else {
            if let attributedSubtitle = subtitle.attributedSubtitle {
                return Bubble.showBubble(title: title,
                                         attributedSubtitle: attributedSubtitle,
                                         buttons: buttons,
                                         resultBlock: resultBlock)
            } else {
                return Bubble.showBubble(title: title,
                                         subtitle: subtitle.subtitle,
                                         buttons: buttons,
                                         resultBlock: resultBlock)
            }
        }
    }

    private static func imageSize(image: BubbleImage) -> CGSize {
        var imageSize: CGSize = .zero
        if availableSize(size: image.configuration.customImageSize) {
            imageSize = image.configuration.customImageSize
        } else if let localImage = image.localImage {
            imageSize = localImage.image.size
        } else if let netImage = image.netImage, netImage.imageUrl.hasPrefix("http") {
            imageSize = netImage.imageSize
        }
        return imageSize
    }

    private static func availableSize(size: CGSize) -> Bool {
        return size.width > 0 && size.height > 0
    }

    private static func imageModel(imageFitWidth: Bool,
                                   realImageSize: CGSize,
                                   image: BubbleImage) -> ImageBubbleModel {
        var imageModel = ImageBubbleModel()
        if let localImage = image.localImage {
            imageModel = BubbleModelEditor.createImageBubbleModel(image: localImage.image,
                                                                  imageSize: realImageSize,
                                                                  imageFitWidth: imageFitWidth)
        } else if let netImage = image.netImage, netImage.imageUrl.hasPrefix("http") {
            imageModel = BubbleModelEditor.createImageBubbleModel(imageUrl: netImage.imageUrl,
                                                                  placeholder: netImage.placeholder,
                                                                  errorImage: netImage.errorImage,
                                                                  imageSize: realImageSize,
                                                                  imageFitWidth: imageFitWidth)
        }
        return imageModel
    }

    private static func realImageSize(imageSize: CGSize, sizeType: BubbleImageSize) -> (Bool, CGSize) {
        var realImageSize: CGSize = imageSize
        var imageFitWidth = true

        if availableSize(size: imageSize) {
            switch sizeType {
            case .common:
                realImageSize = imageSize
                imageFitWidth = true
            case .large:
                realImageSize = imageSize
                imageFitWidth = true
            case .small:
                realImageSize = CGSize(width: 100.0, height: imageSize.height * 100 / imageSize.width)
                imageFitWidth = false
            case .tiny:
                realImageSize = CGSize(width: 50.0, height: imageSize.height * 50.0 / imageSize.width)
                imageFitWidth = false
            }
        }

        return (imageFitWidth, realImageSize)
    }

    private static func fixImageAndTextMargin(imageModel: ImageBubbleModel,
                                              titleModel: TextBubbleModel,
                                              subtitleModel: TextBubbleModel,
                                              sizeType: BubbleImageSize,
                                              position: BubbleImagePosition) {
        switch position {
        case .middle:
            if sizeType == .large {
                var imageMargin = imageModel.margin
                imageMargin.left = 0
                imageMargin.right = 0

                imageModel.margin = imageMargin
            } else if sizeType == .common {
                var imageMargin = imageModel.margin
                imageMargin.left = 24.0
                imageMargin.right = 24.0

                imageModel.margin = imageMargin
            }
        case .top:
            if sizeType != .small {
                if sizeType == .large {
                    var imageMargin = imageModel.margin
                    imageMargin.left = 0
                    imageMargin.right = 0
                    imageMargin.top = 0

                    imageModel.margin = imageMargin
                } else if sizeType == .common {
                    var imageMargin = imageModel.margin
                    imageMargin.left = 24.0
                    imageMargin.right = 24.0
                    imageMargin.top = 16.0

                    imageModel.margin = imageMargin
                }

                var titleModelMargin = titleModel.margin
                titleModelMargin.top = 25.0
                titleModel.margin = titleModelMargin

                var subtitleModelMargin = subtitleModel.margin
                subtitleModelMargin.top = 12.0
                subtitleModel.margin = subtitleModelMargin
            }
        }
    }
}
