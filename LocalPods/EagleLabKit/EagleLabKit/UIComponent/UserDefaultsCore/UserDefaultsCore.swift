//
//  UserDefaultsCore.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/6/16.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import DefaultsKit

class UserDefaultsCore {
    /// 存储数据
    /// - Parameters:
    ///   - value: 值
    ///   - key: key
    static func set<ValueType>(value: ValueType, for key: Key<ValueType>) {
        let defaults = Defaults()
        defaults.set(value, for: key)
    }

    /// 拿取数据
    /// - Parameter key: key
    /// - Returns: 值
    static func get<ValueType>(for key: Key<ValueType>) -> ValueType? {
        let defaults = Defaults()
        return defaults.get(for: key)
    }

    /// 判断是否存在 key 对应的值
    /// - Parameter key: key
    /// - Returns: 存在与否
    static func has<ValueType>(_ key: Key<ValueType>) -> Bool {
        let defaults = Defaults()
        return defaults.has(key)
    }

    /// 移除某个 key 对应的数据
    /// - Parameter key: key
    static func remove<ValueType>(_ key: Key<ValueType>) {
        let defaults = Defaults()
        defaults.clear(key)
    }

    /// 移除某 buddle 中的所有数据（默认 main）
    /// - Parameter bundle: Bundle
    static func removeAll(bundle: Bundle = Bundle.main) {
        let defaults = Defaults()
        defaults.removeAll(bundle: bundle)
    }
}
