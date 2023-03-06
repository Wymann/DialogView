//
//  Bundle+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/1/5.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation

extension EagleLabKit where Base == Bundle {
    var displayName: String? {
        return base.infoDictionary?["CFBundleDisplayName"] as? String
    }

    var version: String {
        return base.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var buildVersion: String {
        return base.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "1"
    }

    var appFullVersion: String {
        return version + "(" + buildVersion + ")"
    }

    var bundleIdentifier: String {
        return base.infoDictionary?[kCFBundleIdentifierKey as String] as? String ?? ""
    }

    var bundleIExecutable: String {
        return base.infoDictionary?[kCFBundleExecutableKey as String] as? String ?? ""
    }
}
