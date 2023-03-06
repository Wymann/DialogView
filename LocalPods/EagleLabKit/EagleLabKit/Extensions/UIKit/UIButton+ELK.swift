//
//  UIButton+ELK.swift
//  TCLHome
//
//  Created by lidan on 2022/3/2.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UIButton {
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        base.setBackgroundImage(color?.elk.toImage, for: state)
    }
}
