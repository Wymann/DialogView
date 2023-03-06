//
//  ELKRouterPlugin.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/28.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

public class ELKRouterPlugin<T: ELKRouterTypeAllowed>: ELKRouterPluggable {
    public init() { }

    open func should(open type: T) -> Bool {
        return true
    }

    open func prepare(open type: T, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    open func will(open type: T, controller: ELKRouterAllowed) { }

    open func did(open type: T, controller: ELKRouterAllowed) { }
}
