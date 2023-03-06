//
//  ELKDefaultPageModel.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/13.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class ELKDefaultPageModel {
    static let empty: ELKDefaultPageModel = .init(image: nil)

    /// 图片
    var image: UIImage?

    /// 标题
    var title: String = ""

    /// 副标题
    var subtitle: String = ""

    /// 按钮文字
    var buttonText: String = ""

    init(image: UIImage?,
         title: String = "",
         subtitle: String = "",
         buttonText: String = "") {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
    }
}
