//
//  ELKCycleLayout.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/6.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class ELKCycleLayout: UICollectionViewFlowLayout {
    var scale: CGFloat = 1 {
        didSet {
            if scale >= 1 {
                invalidateLayout()
            }
        }
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        switch scrollDirection {
        case .horizontal:
            let offset = (collectionView.frame.size.width - itemSize.width) / 2
            sectionInset = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
        case .vertical:
            let offset = (collectionView.frame.size.height - itemSize.height) / 2
            sectionInset = UIEdgeInsets(top: offset, left: 0, bottom: offset, right: 0)
        default: return
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect), let collectionView = collectionView else {
            return nil
        }

        guard let layoutAttributes = NSArray(array: attributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
            return nil
        }

        for layoutAttribute in layoutAttributes {
            var scale: CGFloat = 1
            var absOffset: CGFloat = 0
            let centerX = collectionView.bounds.size.width * 0.5 + collectionView.contentOffset.x
            let centerY = collectionView.bounds.size.height * 0.5 + collectionView.contentOffset.y
            if scrollDirection == .horizontal {
                absOffset = abs(layoutAttribute.center.x - centerX)
                let distance = itemSize.width + minimumLineSpacing
                if absOffset < distance {
                    scale = (1 - absOffset / distance) * (self.scale - 1) + 1
                }
            } else {
                absOffset = abs(layoutAttribute.center.y - centerY)
                let distance = itemSize.height + minimumLineSpacing
                if absOffset < distance {
                    scale = (1 - absOffset / distance) * (self.scale - 1) + 1
                }
            }

            layoutAttribute.zIndex = Int(scale * 1000)
            layoutAttribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return layoutAttributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var minSpace = CGFloat.greatestFiniteMagnitude
        var offset = proposedContentOffset

        guard let collectionView = collectionView else {
            return offset
        }

        let centerX = offset.x + collectionView.bounds.size.width / 2
        let centerY = offset.y + collectionView.bounds.size.height / 2
        var visibleRect: CGRect
        if scrollDirection == .horizontal {
            visibleRect = CGRect(origin: CGPoint(x: offset.x, y: 0), size: collectionView.bounds.size)
        } else {
            visibleRect = CGRect(origin: CGPoint(x: 0, y: offset.y), size: collectionView.bounds.size)
        }
        if let attributes = layoutAttributesForElements(in: visibleRect) {
            for attribute in attributes {
                if scrollDirection == .horizontal {
                    if abs(minSpace) > abs(attribute.center.x - centerX) {
                        minSpace = attribute.center.x - centerX
                    }
                } else {
                    if abs(minSpace) > abs(attribute.center.y - centerY) {
                        minSpace = attribute.center.y - centerY
                    }
                }
            }
        }
        if scrollDirection == .horizontal {
            offset.x += minSpace
        } else {
            offset.y += minSpace
        }

        return offset
    }
}
