//
//  UIColor+ELK.swift
//  TCLHome
//
//  Created by lidan on 2021/12/31.
//  Copyright © 2021 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension UIColor {
    private(set) static var needReplaceColors: [String]?
    private(set) static var replaceColor: String?

    convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue = CGFloat(hex3 & 0x00F) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green = CGFloat((hex4 & 0x0F00) >> 8) / divisor
        let blue = CGFloat((hex4 & 0x00F0) >> 4) / divisor
        let alpha = CGFloat(hex4 & 0x000F) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
        let blue = CGFloat(hex6 & 0x0000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red = CGFloat((hex8 & 0xFF00_0000) >> 24) / divisor
        let green = CGFloat((hex8 & 0x00FF_0000) >> 16) / divisor
        let blue = CGFloat((hex8 & 0x0000_FF00) >> 8) / divisor
        let alpha = CGFloat(hex8 & 0x0000_00FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        var hexInt = hex
        if let replaceHexString = Self.colorValueRequireReplaceDefaultThemeColorWithHex(hex: hex) as String?, let replaceInt = UInt32(replaceHexString) {
            hexInt = replaceInt
            print("\(hex):1已替换成默认颜色\(hexInt)")
        }
        self.init(hex6: hexInt, alpha: alpha)
    }

    convenience init?(hexString: String) {
        var hex = hexString
        if let replaceHexString = Self.colorValueRequireReplaceDefaultThemeColorWithString(hexString: hexString) {
            // 替换颜色后处理
            hex = replaceHexString
            print("\(hexString):已替换成默认颜色\(hex)")
        }
        var value = UInt64(0)
        if hex.lowercased().hasPrefix("#") {
            hex = String(hex[String.Index(utf16Offset: 1, in: hex)...])
        } else if hex.lowercased().hasPrefix("0x") {
            hex = String(hex[String.Index(utf16Offset: 2, in: hex)...])
        }

        guard Scanner(string: hex).scanHexInt64(&value) else { return nil }
        switch hex.count {
        case 3: self.init(hex3: UInt16(value))
        case 4: self.init(hex4: UInt16(value))
        case 6: self.init(hex6: UInt32(value))
        case 8: self.init(hex8: UInt32(value))
        default: return nil
        }
    }

    convenience init?(color1: UIColor, color2: UIColor, ratio: CGFloat) {
        var reset = ratio
        if ratio > 1.0 { reset = 1.0 }

        guard let components1 = color1.cgColor.components, let components2 = color2.cgColor.components else { return nil }
        let red = components1[0] * reset + components2[0] * (1 - reset)
        let green = components1[1] * reset + components2[1] * (1 - reset)
        let blue = components1[2] * reset + components2[2] * (1 - reset)
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    func hexStringCount(hexString: String) -> Int {
        var hex = hexString
        if hex.lowercased().hasPrefix("#") {
            hex = String(hex[String.Index(utf16Offset: 1, in: hex)...])
        } else if hex.lowercased().hasPrefix("0x") {
            hex = String(hex[String.Index(utf16Offset: 2, in: hex)...])
        }
        return hex.count
    }
}

extension UIColor {
    static func setNeedReplaceColors(colors: [String]?) {
        Self.needReplaceColors = colors
    }

    static func setReplaceColor(color: String?) {
        Self.replaceColor = color
    }

    static func colorValueRequireReplaceDefaultThemeColorWithHex(hex: UInt32) -> String? {
        if let colorColors = Self.needReplaceColors, let defaultColor = Self.replaceColor {
            for valueString in colorColors where valueString.contains(String(hex, radix: 16)) {
                return defaultColor
            }
        }
        return nil
    }

    static func colorValueRequireReplaceDefaultThemeColorWithString(hexString: String) -> String? {
        if let colorColors = Self.needReplaceColors, let defaultColor = Self.replaceColor {
            for valueString in colorColors where hexString.contains(valueString) {
                return defaultColor
            }
        }
        return nil
    }
}

extension EagleLabKit where Base == String {
    var toUIColor: UIColor? {
        return UIColor(hexString: base)
    }
}

extension EagleLabKit where Base == UIColor {
    var toImage: UIImage? {
        return toImage(size: CGSize(width: 1.0, height: 1.0))
    }

    func toImage(size: CGSize) -> UIImage? {
        guard size.width > 0, size.height > 0 else { return nil }
        defer { UIGraphicsEndImageContext() }

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        base.setFill()
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
