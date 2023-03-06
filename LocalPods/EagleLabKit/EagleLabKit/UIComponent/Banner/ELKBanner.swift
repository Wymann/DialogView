//
//  UIWindow+Banner.swift
//  TCLHome
//
//  Created by lidan on 2022/1/7.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base == UIWindow {
    enum AssociatedKey {
        static var bannerKey: Void?
        static var bannerTextKey: Void?
        static var titleLabelKey: Void?
    }

    static func register(isDebug: Bool = true) {
        Override.swizzleMethod(targetClass: Override.class(of: UIWindow.self), originalSelector: #selector(UIWindow.layoutSubviews), swizzledSelector: #selector(UIWindow.elk_layoutSubviews))
    }

    static var debugBannerText: String? {
        get { Association.getObject(Base.self, &AssociatedKey.bannerTextKey) }
        set { Association.setRetainedObject(Base.self, &AssociatedKey.bannerTextKey, newValue) }
    }
}

@objc
private extension UIWindow {
    func elk_layoutSubviews() {
        elk_layoutSubviews()

        elk_updateDebugModeBannerContent()

        if isKeyWindow {
            // 修复 iOS 13 及以后机型 Modal 控制器 Banner 被遮住问题
            debugModeBanner.removeFromSuperview()
            addSubview(debugModeBanner)
        }
    }
}

extension UIWindow {
    private var debugModeBanner: UIView {
        guard let self = Association<UIView>.getObject(self, &EagleLabKit.AssociatedKey.bannerKey) else {
            let banner = UIView()
            banner.backgroundColor = .clear
            banner.isUserInteractionEnabled = false
            banner.addSubview(titleLabel)
            Association.setRetainedObject(self, &EagleLabKit.AssociatedKey.bannerKey, banner)

            return banner
        }
        return self
    }

    private var titleLabel: UILabel {
        guard let self = Association<UILabel>.getObject(self, &EagleLabKit.AssociatedKey.titleLabelKey) else {
            let label = UILabel()
            label.backgroundColor = .systemOrange.withAlphaComponent(0.5)
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12.0, weight: .medium)
            label.textColor = .black
            label.isUserInteractionEnabled = false
            Association.setRetainedObject(self, &EagleLabKit.AssociatedKey.titleLabelKey, label)

            return label
        }
        return self
    }

    private func elk_updateDebugModeBannerContent() {
        // 还原之前旋转状态
        debugModeBanner.transform = CGAffineTransform.identity

        let navigationBarHeight = safeAreaInsets.top + 44.0
        let widthAndHeight = sqrt(2 * (navigationBarHeight * navigationBarHeight)) // 斜边
        let bannerX = bounds.width - widthAndHeight * 0.5
        let bannerY = -widthAndHeight * 0.5
        debugModeBanner.frame = CGRect(x: bannerX, y: bannerY, width: widthAndHeight, height: widthAndHeight)
        debugModeBanner.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)

        let labelHeight = 24.0
        let labelX = (debugModeBanner.bounds.width - widthAndHeight) * 0.5
        let labelY = debugModeBanner.bounds.height - labelHeight
        titleLabel.frame = CGRect(x: labelX, y: labelY, width: widthAndHeight, height: labelHeight)
        titleLabel.text = UIWindow.elk.debugBannerText
    }
}
