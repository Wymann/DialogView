//
//  BubbleShareCell.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/10/8.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

class BubbleShareCell: UICollectionViewCell {
    var model: ShareModel = .empty {
        didSet {
            updateViewContents()
        }
    }

    private lazy var imageView = UIImageView()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(hexString: "#2D3132")
        titleLabel.textAlignment = .center
        titleLabel.font = BubbleConfig.normalFont(ofSize: 14.0)
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addViewContents()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BubbleShareCell {
    private func addViewContents() {
        let imageViewW = min(frame.width, 60.0)
        imageView.frame = CGRect(x: (frame.width - imageViewW) / 2, y: 0, width: imageViewW, height: imageViewW)
        titleLabel.frame = CGRect(x: 0, y: frame.height - 20.0, width: frame.width, height: 20.0)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }

    private func updateViewContents() {
        titleLabel.text = model.title
        imageView.image = model.icon
    }
}
