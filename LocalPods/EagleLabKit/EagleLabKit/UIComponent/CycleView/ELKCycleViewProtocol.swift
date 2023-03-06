//
//  ELKCycleViewProtocol.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/4/6.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

protocol ELKCycleViewDatasource: AnyObject {
    /// 注册 cell，[重用标志符：cell 类名]
    func cycleViewRegisterCellClasses() -> [String: AnyClass]

    /// cell 赋值
    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell

    /// pageControl
    func cycleViewConfigurePageControl(_ cycleView: ELKCycleView, pageControl: ELKPageControl)
}

extension ELKCycleViewDatasource {
    /// pageControl
    func cycleViewConfigurePageControl(_ cycleView: ELKCycleView, pageControl: ELKPageControl) { }
}

protocol ELKCycleViewDelegate: AnyObject {
    /// 开始拖拽
    func cycleViewBeginDragingIndex(_ cycleView: ELKCycleView, index: Int)

    /// 滚动到 index
    func cycleViewDidScrollToIndex(_ cycleView: ELKCycleView, index: Int)

    /// 点击了 index
    func cycleViewDidSelectedIndex(_ cycleView: ELKCycleView, index: Int)
}

extension ELKCycleViewDelegate {
    /// 开始拖拽
    func cycleViewBeginDragingIndex(_ cycleView: ELKCycleView, index: Int) { }

    /// 滚动到 index
    func cycleViewDidScrollToIndex(_ cycleView: ELKCycleView, index: Int) { }

    /// 点击了 index
    func cycleViewDidSelectedIndex(_ cycleView: ELKCycleView, index: Int) { }
}
