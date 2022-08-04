//
//  Dialog+LocalImage.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

// MARK: 自动显示弹框

extension EagleLabKit where Base: Dialog {
    /// 显示图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（支持纯文本和富文本）
    ///   - image: 图片（支持本地图片和网络图片）
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    @discardableResult
    static func showDialog(title: String,
                           subtitle: DialogSubtitle,
                           image: DialogImage,
                           buttons: [String]?,
                           resultBlock: DialogView.DialogViewResult?) -> DialogView {
        let view = dialog(title: title,
                          subtitle: subtitle,
                          image: image,
                          buttons: buttons,
                          resultBlock: resultBlock)
        Dialog.addDialog(dialogView: view)
        return view
    }
}

// MARK: 生成弹框，不自动显示

extension EagleLabKit where Base: Dialog {
    /// 图片弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题（支持纯文本和富文本）
    ///   - image: 图片（支持本地图片和网络图片）
    ///   - buttons: 按钮
    ///   - resultBlock: 结果回调
    /// - Returns: DialogView
    static func dialog(title: String,
                       subtitle: DialogSubtitle,
                       image: DialogImage,
                       buttons: [String]?,
                       resultBlock: DialogView.DialogViewResult?) -> DialogView {
        if image.style != .none {
            var array: [BasicDialogModel] = []

            let imageSize: CGSize = imageSize(image: image)
            let (imageFitWidth, realImageSize) = realImageSize(imageSize: imageSize, sizeType: image.configuration.sizeType)
            let imageModel: ImageDialogModel = imageModel(imageFitWidth: imageFitWidth,
                                                          realImageSize: realImageSize,
                                                          image: image)

            if image.configuration.position == .top { array.append(imageModel) }

            var textModel: TextDialogModel = .init()
            if !title.isEmpty {
                textModel = DialogModelEditor.createTextDialogModel(title: title, titleColor: "")
                array.append(textModel)
            }

            var textModel1: TextDialogModel = .init()
            if !subtitle.subtitle.isEmpty {
                textModel1 = DialogModelEditor.createTextDialogModel(subtitle: subtitle.subtitle, subtitleColor: "")
                array.append(textModel1)
            } else if let attributedSubText = subtitle.attributedSubtitle, !attributedSubText.string.isEmpty {
                textModel1 = DialogModelEditor.createTextDialogModel(attributedSubtitle: attributedSubText, subtitleColor: "")
                array.append(textModel1)
            }

            if image.configuration.position == .middle { array.append(imageModel) }

            DialogModelEditor.createModelMargin(models: &array, existTitle: !title.isEmpty)

            if let buttonsArray = buttons, !buttonsArray.isEmpty {
                let buttonsModel = DialogModelEditor.createButtonsDialogModel(buttons: buttonsArray)
                array.append(buttonsModel)
            }

            fixImageAndTextMargin(imageModel: imageModel,
                                  titleModel: textModel,
                                  subtitleModel: textModel1,
                                  sizeType: image.configuration.sizeType,
                                  position: image.configuration.position)

            let view = DialogView()
            view.configDialogView(dialogModels: array)
            view.dialogResult = resultBlock
            return view

        } else {
            if let attributedSubtitle = subtitle.attributedSubtitle {
                return Dialog.elk.showDialog(title: title,
                                             attributedSubtitle: attributedSubtitle,
                                             buttons: buttons,
                                             resultBlock: resultBlock)
            } else {
                return Dialog.elk.showDialog(title: title,
                                             subtitle: subtitle.subtitle,
                                             buttons: buttons,
                                             resultBlock: resultBlock)
            }
        }
    }

    private static func imageSize(image: DialogImage) -> CGSize {
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
                                   image: DialogImage) -> ImageDialogModel {
        var imageModel = ImageDialogModel()
        if let localImage = image.localImage {
            imageModel = DialogModelEditor.createImageDialogModel(image: localImage.image,
                                                                  imageSize: realImageSize,
                                                                  imageFitWidth: imageFitWidth)
        } else if let netImage = image.netImage, netImage.imageUrl.hasPrefix("http") {
            imageModel = DialogModelEditor.createImageDialogModel(imageUrl: netImage.imageUrl,
                                                                  placeholder: netImage.placeholder,
                                                                  errorImage: netImage.errorImage,
                                                                  imageSize: realImageSize,
                                                                  imageFitWidth: imageFitWidth)
        }
        return imageModel
    }

    private static func realImageSize(imageSize: CGSize, sizeType: DialogImageSize) -> (Bool, CGSize) {
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

    private static func fixImageAndTextMargin(imageModel: ImageDialogModel,
                                              titleModel: TextDialogModel,
                                              subtitleModel: TextDialogModel,
                                              sizeType: DialogImageSize,
                                              position: DialogImagePosition) {
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
