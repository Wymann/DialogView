//
//  WKWebView+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/2/21.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import WebKit

private let userAgentWebView = WKWebView()
private var defaultUserAgentString = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
private var customUserAgentString = defaultUserAgentString

extension EagleLabKit where Base: WKWebView {
    /// 首先需要 App 启动时调用
    static func configurationUserAgent() {
        // Mozilla/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 AppName/x.x.x (iPhone; iOS 14.6; Scale/3.00)
        userAgentWebView.evaluateJavaScript("navigator.userAgent") { result, _ in
            // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
            if let result = result as? String, !result.isEmpty {
                defaultUserAgentString = result
            }

            let executable = Bundle.main.elk.bundleIExecutable
            let version = Bundle.main.elk.version
            let buildVersion = Bundle.main.elk.buildVersion
            let model = UIDevice.current.model
            let systemVersion = UIDevice.current.systemVersion
            let scale = UIScreen.main.scale
            let custom = String(format: "%@/%@ (%@; iOS %@; Scale/%0.2f)", executable, "\(version).\(buildVersion)", model, systemVersion, scale)

            customUserAgentString.append(" ") // 空格分割
            customUserAgentString.append(custom)
        }
    }

    /// 获取系统默认 UserAgent
    static var defaultUserAgent: String {
        return defaultUserAgentString
    }

    /// 获取初始自定义 UserAgent
    static var customUserAgent: String {
        return customUserAgentString
    }
}
