//
//  EagleLabKit.swift
//  TCLHome
//
//  Created by lidan on 2021/12/9.
//  Copyright © 2021 TCL Eagle Lab. All rights reserved.
//

struct EagleLabKit<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

protocol EagleLabKitCompatible {
    associatedtype EagleLabKitBase

    static var elk: EagleLabKit<EagleLabKitBase>.Type { get set }

    var elk: EagleLabKit<EagleLabKitBase> { get set }
}

extension EagleLabKitCompatible {
    static var elk: EagleLabKit<Self>.Type {
        get { EagleLabKit<Self>.self }
        set { }
    }

    var elk: EagleLabKit<Self> {
        get { EagleLabKit(self) }
        set { }
    }
}

import CoreGraphics
import Foundation

extension NSObject: EagleLabKitCompatible { }

extension Notification.Name: EagleLabKitCompatible { }

extension Data: EagleLabKitCompatible { }

extension String: EagleLabKitCompatible { }

extension CGSize: EagleLabKitCompatible { }

extension Date: EagleLabKitCompatible { }

extension Dictionary: EagleLabKitCompatible { }
