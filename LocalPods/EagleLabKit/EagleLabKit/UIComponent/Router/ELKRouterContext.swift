//
//  ELKRouterContext.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/1.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

struct ELKRouterContext {
    let callback: (Bool) -> Void

    init(_ completion: @escaping (Bool) -> Void = { _ in }) {
        callback = completion
    }
}
