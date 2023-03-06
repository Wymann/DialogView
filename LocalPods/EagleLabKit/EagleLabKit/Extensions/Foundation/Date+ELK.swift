//
//  Date+ELK.swift
//  TCLHome
//
//  Created by wangjian on 2022/3/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

extension EagleLabKit where Base == Date {
    func isToday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let now = calendar.dateComponents(unit, from: Date())
        let old = calendar.dateComponents(unit, from: base)

        return (old.year == now.year) &&
            (old.month == now.month) &&
            (old.day == now.day)
    }

    func isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let now = calendar.dateComponents(unit, from: Date())
        let old = calendar.dateComponents(unit, from: base)
        guard let oldDay = old.day, let nowDay = now.day else {
            return false
        }

        let count = nowDay - oldDay
        return (old.year == now.year) &&
            (old.month == now.month) &&
            (count == 1)
    }

    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let now = calendar.dateComponents([.year], from: Date())
        let old = calendar.dateComponents([.year], from: base)
        let result = now.year == old.year
        return result
    }

    func components() -> DateComponents {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year, .hour, .minute]
        let now = calendar.dateComponents(unit, from: base)
        return now
    }

    static func timeStamp() -> String {
        let currentDate = Date(timeIntervalSinceNow: 0)
        let timeInterval = currentDate.timeIntervalSince1970
        return String(format: "%.0f", timeInterval)
    }

    /**
     * @brief 获取当前时间戳（13位，毫秒）
     * @return 返回时间戳
     */
    static func timeStamp13() -> String {
        let currentDate = Date(timeIntervalSinceNow: 0)
        let timeInterval = currentDate.timeIntervalSince1970 * 1000
        return String(format: "%.0f", timeInterval)
    }
}
