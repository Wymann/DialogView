//
//  Dictionary+ELK.swift
//  TCLHome
//
//  Created by LiangYanbo on 2022/8/16.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

extension EagleLabKit where Base == [String: Any] {
    var jsonString: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: base, options: [.prettyPrinted])
            if let string = String(data: jsonData, encoding: String.Encoding.utf8) {
                return string
            }

        } catch {
            return ""
        }
//        guard let jsonData = try JSONSerialization.data(withJSONObject: base, options: [.prettyPrinted]) else {
//            return ""
//        }
        return ""
    }
}
