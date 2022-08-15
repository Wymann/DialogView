//
//  UILabel+Bubble.swift
//  BubbleView
//
//  Created by huaizhang.chen on 2022/8/15.
//

import UIKit

extension UILabel {

    /// 计算 UILabel height
    /// - Parameters:
    ///   - text: 文本
    ///   - width: 固定宽度
    ///   - font: 字体
    /// - Returns: 高度
    static func b_labelHeight(text: String?, width: CGFloat, font: UIFont?) -> CGFloat {
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
    static func b_labelHeight(attributed: NSAttributedString?, width: CGFloat, maxLines: Int) -> CGFloat {
        guard let attributedText = attributed, !attributedText.string.isEmpty, width > 0.0 else {
            return 0.0
        }

        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat(MAXFLOAT)))
        label.attributedText = attributedText
        label.numberOfLines = maxLines

        let labelSize: CGSize = label.sizeThatFits(label.bounds.size)
        return ceil(labelSize.height)
    }
}
