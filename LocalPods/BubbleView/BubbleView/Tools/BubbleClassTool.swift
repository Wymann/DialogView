//
//  BubbleClassTool.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

class BubbleClassTool {
    /// 通过类名获取类
    /// - Parameter classString: 类名
    /// - Returns: class
    class func getClass(classString: String) -> AnyClass? {
        guard let bundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return nil
        }

        var anyClass: AnyClass? = NSClassFromString(bundleName + "." + classString)
        if anyClass == nil {
            anyClass = NSClassFromString(classString)
        }
        return anyClass
    }
}
