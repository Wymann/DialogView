//
//  UIImage+ELK.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/3.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UIImage {
    static func base64StrImage(_ base64String: String) -> UIImage {
        guard let data = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters),
              let image = UIImage(data: data as Data) else {
            return UIImage()
        }
        return image
    }

    /// 图片压缩
    static func compressImage(_ data: Data, toLength: Int) -> Data? {
        let temp = CGFloat(toLength) / CGFloat(data.count)
        if temp > 1 {
            return data
        }
        let image = UIImage(data: data)
        let resData = image?.jpegData(compressionQuality: temp)
        return resData
    }

    /// 生成某种颜色和特定尺寸的图片
    static func imageSize(color: UIColor?, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        if let cgColor = color?.cgColor {
            context?.setFillColor(cgColor)
        }
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 裁剪圆角
    func imageCornerClip(radius: CGFloat) -> UIImage? {
        let bezierPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: base.size), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))

        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(bezierPath.cgPath)
        context?.clip()
        base.draw(in: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: base.size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
