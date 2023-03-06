//
//  Runtime.swift
//  TCLHome
//
//  Created by lidan on 2022/1/7.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import ObjectiveC

struct Association<T> {
    enum Policy: UInt {
        /** < Specifies a weak reference to the associated object. */
        case assign = 0

        /** < Specifies a strong reference to the associated object.
         *   The association is not made atomically. */
        case retainNonatomic = 1

        /** < Specifies that the associated object is copied.
         *   The association is not made atomically. */
        case copyNonatomic = 3

        /** < Specifies a strong reference to the associated object.
         *   The association is made atomically. */
        case retain = 769

        /** < Specifies that the associated object is copied.
         *   The association is made atomically. */
        case copy = 771
    }

    static func getObject(_ object: Any, _ key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(object, key) as? T
    }

    static func setObject(_ object: Any, _ key: UnsafeRawPointer, _ value: T, _ policy: Policy) {
        if let policy = objc_AssociationPolicy(rawValue: policy.rawValue) {
            objc_setAssociatedObject(object, key, value, policy)
        } else {
            setRetainedObject(object, key, value)
        }
    }

    static func setRetainedObject(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
        objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    static func setCopyObject(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
        objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}

enum Override {
    static func `class`(of value: AnyObject.Type) -> AnyClass? {
        return NSClassFromString(String(describing: value))
    }

    static func swizzleMethod(targetClass: AnyClass?, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(targetClass, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(targetClass, swizzledSelector) else { return }

        let isSuccess = class_addMethod(targetClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if isSuccess {
            class_replaceMethod(targetClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
