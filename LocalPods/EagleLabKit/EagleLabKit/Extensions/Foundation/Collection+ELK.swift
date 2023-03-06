//
//  Collection+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/7/29.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

extension EagleLabKit where Base: Collection {
    var isNotEmpty: Bool {
        return base.isEmpty ? false : true
    }
}
