//
//  UILabel+ELK.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/1/20.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UILabel {
    /// 计算 UILabel size
    /// - Parameters:
    ///   - text: 文本
    ///   - font: 字体
    /// - Returns: size
    static func labelSize(text: String?, font: UIFont?) -> CGSize {
        guard let textString = text, !textString.isEmpty, let textFont = font else {
            return CGSize.zero
        }

        let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        let labelSize = textString.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context: nil)
        return CGSize(width: ceil(labelSize.width), height: ceil(labelSize.height))
    }

    /// 计算 UILabel height
    /// - Parameters:
    ///   - text: 文本
    ///   - width: 固定宽度
    ///   - font: 字体
    /// - Returns: 高度
    static func labelHeight(text: String?, width: CGFloat, font: UIFont?) -> CGFloat {
        guard let textString = text, !textString.isEmpty, let textFont = font, width > 0.0 else {
            return 0.0
        }

        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let labelSize = textString.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: textFont], context: nil)
        return ceil(labelSize.height)
    }

    /// 计算 UILabel height
    /// - Parameters:
    ///   - attributed: 需要操作的富文本
    ///   - width: 宽度
    ///   - maxLines: 最大行数
    /// - Returns: 计算出的富文本高度
    static func labelHeight(attributed: NSAttributedString?, width: CGFloat, maxLines: Int) -> CGFloat {
        guard let attributedText = attributed, !attributedText.string.isEmpty, width > 0.0 else {
            return 0.0
        }

        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat(MAXFLOAT)))
        label.attributedText = attributedText
        label.numberOfLines = maxLines

        let labelSize: CGSize = label.sizeThatFits(label.bounds.size)
        return ceil(labelSize.height)
    }

    func setLineSpace(_ lineSpace: CGFloat) {
        guard let text = base.text else { return }
        if lineSpace < 0.01 {
            return
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.lineBreakMode = base.lineBreakMode
        paragraphStyle.alignment = base.textAlignment

        let attributedString = NSMutableAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
        base.attributedText = attributedString
    }
}
