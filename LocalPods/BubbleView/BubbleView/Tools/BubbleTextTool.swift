//
//  BubbleTextTool.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/22.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import CoreText
import Foundation
import UIKit

class BubbleTextTool {
    struct AttributedStringConfig {
        var textContent: String = "" // 文本内容
        var textAlignment: NSTextAlignment = .left // 文本排版
        var fontSize: CGFloat = 14.0 // 文本字体
        var lineSpace: CGFloat = 3.0 // 行间距
        var textColor: UIColor = .black // 文本颜色
        var richTextArray: [[String: Any]] = [] // 富文本数据
        var breakMode: NSLineBreakMode = .byTruncatingTail // 换行模式
    }

    /// 创建富文本数据
    /// - Parameter configuration: 富文本内容
    /// - Returns: 富文本
    class func createAttributedString(configuration: AttributedStringConfig) -> NSAttributedString {
        let range = NSRange(location: 0, length: configuration.textContent.count)
        let attributedText = NSMutableAttributedString(string: configuration.textContent)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: configuration.fontSize), range: range)

        addParagraphStyle(configuration: configuration, attributedText: attributedText, range: range)

        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: configuration.textColor, range: range)

        for richDic in configuration.richTextArray {
            if let richType = richDic["richType"] as? String, let rangeArray = richDic["range"] as? [Int] {
                if rangeArray.count != 2 || richType.isEmpty {
                    continue
                }

                let location: Int = rangeArray.first ?? 0
                let length: Int = rangeArray.last ?? 0
                let totalLength: Int = location + length
                if totalLength > configuration.textContent.count || totalLength == 0 {
                    continue
                }

                let richRange = NSRange(location: location, length: length)

                if richType == "color" {
                    if let textColorString: String = richDic["textColor"] as? String, !textColorString.isEmpty {
                        let color = UIColor(hexString: textColorString) ?? UIColor.black
                        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: richRange)
                    } else {
                        continue
                    }
                } else if richType == "link" {
                    if let linkUrl: String = richDic["linkUrl"] as? String, !linkUrl.isEmpty {
                        attributedText.addAttribute(NSAttributedString.Key.link, value: linkUrl, range: richRange)
                    } else {
                        continue
                    }
                } else if richType == "font" {
                    if let fontSize: CGFloat = richDic["fontSize"] as? CGFloat {
                        var font = UIFont()
                        if let bold: Bool = richDic["bold"] as? Bool, bold {
                            font = UIFont.boldSystemFont(ofSize: fontSize)
                        } else {
                            font = UIFont.systemFont(ofSize: fontSize)
                        }
                        attributedText.addAttribute(NSAttributedString.Key.font, value: font, range: richRange)
                    } else {
                        continue
                    }
                }
            }
        }

        return attributedText
    }

    private class func addParagraphStyle(configuration: AttributedStringConfig, attributedText: NSMutableAttributedString, range: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = configuration.lineSpace
        paragraphStyle.lineBreakMode = configuration.breakMode
        paragraphStyle.alignment = configuration.textAlignment
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
    }

    /// 计算文本行数
    /// - Parameters:
    ///   - text: 文本
    ///   - font: 字体
    ///   - width: 控件宽度
    /// - Returns: 文本行数
    class func calculateLines(text: String, font: UIFont, width: CGFloat) -> Int {
        if text.isEmpty {
            return 0
        }

        var fontName = font.fontName
        if fontName == ".SFUI-Regular" {
            fontName = "TimesNewRomanPSMT"
        }

        let myFont = CTFontCreateWithName(fontName as CFString, font.pointSize, nil)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.font, value: myFont, range: NSRange(location: 0, length: attributedText.string.count))
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedText)
        let path = CGMutablePath(rect: CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat(MAXFLOAT)), transform: nil)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0), path, nil)
        let lines = CTFrameGetLines(frame) as Array
        return lines.count
    }
}
