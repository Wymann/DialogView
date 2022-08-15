//
//  UIColor+Bubble.swift
//  BubbleView
//
//  Created by huaizhang.chen on 2022/8/15.
//

import UIKit

extension UIColor {
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
        self.init(hex6: hex, alpha: alpha)
    }

    convenience init?(hexString: String) {
        var hex = hexString
        var value = UInt64(0)
        if hex.lowercased().hasPrefix("#") {
            hex = String(hexString[String.Index(utf16Offset: 1, in: hex)...])
        } else if hex.lowercased().hasPrefix("0x") {
            hex = String(hexString[String.Index(utf16Offset: 2, in: hex)...])
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
}
