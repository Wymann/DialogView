//
//  Data+ELK.swift
//  TCLHome
//
//  Created by lidan on 2021/12/12.
//  Copyright © 2021 TCL Eagle Lab. All rights reserved.
//

import Foundation

extension EagleLabKit where Base == Data {
    var base64EncodeString: String? {
        return base.base64EncodedString(options: [])
    }
}
