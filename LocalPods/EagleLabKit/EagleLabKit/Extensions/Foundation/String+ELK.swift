//
//  String+ELK.swift
//  TCLHome
//
//  Created by lidan on 2021/12/12.
//  Copyright © 2021 TCL Eagle Lab. All rights reserved.
//

import CommonCrypto
import Foundation

extension EagleLabKit where Base == String {
    /// 判断是否为空白字符串
    var isBlank: Bool {
        return base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var base64EncodeString: String? {
        return base.data(using: .utf8)?.base64EncodedString()
    }

    var base64DecodeData: Data? {
        return Data(base64Encoded: base)
    }

    var base64DecodeDataIgnoreUnknownCharacters: Data? {
        return Data(base64Encoded: base, options: .ignoreUnknownCharacters)
    }

    var urlEncodeString: String? {
        return base.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }

    /// 从某个位置开始截取, index: 起点位置
    func substring(from index: Int) -> String {
        if base.count > index {
            let sIndex = base.index(base.startIndex, offsetBy: index)
            let substring = base[sIndex ..< base.endIndex]
            return String(substring)
        }
        return ""
    }

    /// 从零开始截取到某个位置, index: 终点位置
    func substring(to index: Int) -> String {
        if base.count > index {
            let eIndex = base.index(base.startIndex, offsetBy: index)
            let substring = base[base.startIndex ..< eIndex]
            return String(substring)
        }
        return ""
    }

    /// 某个范围内截取, rangs: 范围
    func substring(with range: NSRange) -> String {
        if range.location >= 0, base.count > (range.location + range.length) {
            let sIndex = base.index(base.startIndex, offsetBy: range.location)
            let eIndex = base.index(base.startIndex, offsetBy: range.location + range.length)
            let substring = base[sIndex ..< eIndex]
            return String(substring)
        }
        return ""
    }

    /// 替换其中某个字段为新的字符串
    func replace(with substring: String, replaceString: String) -> String {
        var resultText: String = base
        guard !substring.isEmpty else {
            return resultText
        }
        guard let range = resultText.range(of: substring) else { return resultText }
        resultText.replaceSubrange(range, with: replaceString)
        return resultText
    }

    /// 替换其中某个字段为新的字符串（存在多个需要替换的字段）
    func replace(with substring: String, replaceStrings: [String]) -> String {
        var resultText: String = base
        for replaceString in replaceStrings {
            resultText = resultText.elk.replace(with: substring, replaceString: replaceString)
        }
        return resultText
    }

    /// 获取 substring 的位置
    func range(of substring: String) -> NSRange {
        let totalText = NSString(string: base)
        let range: NSRange = totalText.range(of: substring)
        return range
    }

    var md5: String {
        let string: String = base
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()

        for index in 0 ..< digestLen {
            hash.appendFormat("%02X", result[index])
        }

        result.deallocate()
        return hash as String
    }
}
