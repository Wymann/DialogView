//
//  String+Bubble.swift
//  BubbleView
//
//  Created by huaizhang.chen on 2022/8/15.
//

import Foundation

extension String {
    /// 获取 substring 的位置
    func b_range(of substring: String) -> NSRange {
        let totalText = NSString(string: self)
        let range: NSRange = totalText.range(of: substring)
        return range
    }
}
