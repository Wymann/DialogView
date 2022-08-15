//
//  BasicBubbleElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class BasicBubbleElement: UIView {
    var model: BasicBubbleModel? {
        didSet {
            setUpDetailBubbleElement()
        }
    }

    func setUpDetailBubbleElement() {
        if let unwrappedModel = model {
            backgroundColor = UIColor(hexString: unwrappedModel.backColor)
            layer.cornerRadius = unwrappedModel.cornerRadius
            clipsToBounds = true
        }
    }

    class func elementHeight(model: BasicBubbleModel, elementWidth: CGFloat) -> CGFloat {
        return 0.0
    }
}
