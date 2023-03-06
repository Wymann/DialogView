//
//  ELKViewController.swift
//  TCLHome
//
//  Created by lidan on 2022/1/11.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

class ELKViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}
