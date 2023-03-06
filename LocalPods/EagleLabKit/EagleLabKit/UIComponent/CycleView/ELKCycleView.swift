//
//  ELKCycleView.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/3/31.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

public class ELKCycleView: UIView {
    /// 配置
    private var configuration: ELKCycleConfig

    /// 代理
    private weak var delegate: ELKCycleViewDelegate?
    private weak var datasource: ELKCycleViewDatasource?

    private lazy var flowLayout: ELKCycleLayout = {
        let layout = ELKCycleLayout()
        layout.minimumInteritemSpacing = 10000
        layout.minimumLineSpacing = self.configuration.itemSpacing
        layout.scrollDirection = self.configuration.scrollDirection
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.0)
        return collectionView
    }()

    private lazy var pageControl: ELKPageControl = {
        let pageControl = ELKPageControl()
        pageControl.isHidden = true
        return pageControl
    }()

    private lazy var placeholder = UIImageView()

    private var timer: Timer?
    private var itemsCount: Int = 0
    private var realItemsCount: Int = 0

    /// 当前显示的位置
    var currentIndex: Int {
        return getCurrentIndex()
    }

    /// 当前显示的 cell
    var currentCell: UICollectionViewCell? {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        return collectionView.cellForItem(at: indexPath)
    }

    init(frame: CGRect,
         configuration: ELKCycleConfig,
         datasource: ELKCycleViewDatasource?,
         delegate: ELKCycleViewDelegate?) {
        self.configuration = configuration
        self.delegate = delegate
        self.datasource = datasource
        super.init(frame: frame)

        if let datasource = datasource {
            let cellClasses = datasource.cycleViewRegisterCellClasses()
            if !cellClasses.isEmpty {
                cellClasses.forEach {
                    if let cellClass = $0.value as? UICollectionViewCell.Type {
                        self.collectionView.register(cellClass.self, forCellWithReuseIdentifier: $0.key)
                    }
                }
            }
        }

        setupPlaceholder()
        setupCollectionView()
        setupPageControl()
    }

    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            startTimer()
        } else {
            cancelTimer()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        datasource?.cycleViewConfigurePageControl(self, pageControl: pageControl)
        if flowLayout.itemSize != .zero { return }
        flowLayout.itemSize = configuration.itemSize != nil ? configuration.itemSize! : bounds.size
        dealFirstPage()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI

extension ELKCycleView {
    private func setupPlaceholder() {
        addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        let hCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[placeholder]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholder": placeholder])
        let vCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[placeholder]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["placeholder": placeholder])
        addConstraints(hCons)
        addConstraints(vCons)
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let hCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["collectionView": collectionView])
        let vCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|",
                                                   options: NSLayoutConstraint.FormatOptions(),
                                                   metrics: nil,
                                                   views: ["collectionView": collectionView])
        addConstraints(hCons)
        addConstraints(vCons)
    }

    private func setupPageControl() {
        pageControl = ELKPageControl()
        addSubview(pageControl)
    }
}

// MARK: - 刷新及滚动操作

public extension ELKCycleView {
    /// 刷新数据
    func reloadItemsCount(_ count: Int) {
        cancelTimer()
        if configuration.isAutomatic { startTimer() }
        realItemsCount = count
        placeholder.isHidden = realItemsCount != 0
        setItemsCount()
        dealFirstPage()
        pageControl.numberOfPages = realItemsCount
        pageControl.currentPage = getCurrentIndex() % realItemsCount
    }

    /// 滚动到下一页
    func scrollToNext() {
        timeRepeat()
    }

    private func setItemsCount() {
        itemsCount = realItemsCount <= 1 || !configuration.isInfinite ? realItemsCount : realItemsCount * 200
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - 处理第一帧和最后一帧

extension ELKCycleView {
    private func dealFirstPage() {
        if collectionView.frame.size == .zero { return }
        if getCurrentIndex() == 0, itemsCount > 1 {
            var targetIndex = configuration.isInfinite ? itemsCount / 2 : 0
            if let initialIndex = configuration.initialIndex {
                targetIndex += max(min(initialIndex, realItemsCount - 1), 0)
                configuration.initialIndex = nil
            }
            if let attributes = collectionView.layoutAttributesForItem(at: IndexPath(item: targetIndex, section: 0)) {
                if configuration.scrollDirection == .horizontal {
                    let edgeLeft = (collectionView.bounds.width - flowLayout.itemSize.width) / 2
                    collectionView.setContentOffset(CGPoint(x: attributes.frame.minX - edgeLeft, y: 0), animated: false)
                } else {
                    let edgeTop = (collectionView.bounds.height - flowLayout.itemSize.height) / 2
                    collectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.minY - edgeTop), animated: false)
                }
            }
        }
    }

    private func dealLastPage() {
        if getCurrentIndex() == itemsCount - 1, itemsCount > 1 {
            let targetIndex = configuration.isInfinite ? itemsCount / 2 - 1 : realItemsCount - 1
            let scrollPosition: UICollectionView.ScrollPosition = configuration.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0),
                                        at: scrollPosition,
                                        animated: false)
        }
    }
}

// MARK: - 定时器操作

extension ELKCycleView {
    private func startTimer() {
        if !configuration.isAutomatic { return }
        if itemsCount <= 1 { return }
        cancelTimer()
        timer = Timer(timeInterval: Double(configuration.timeInterval),
                      target: self,
                      selector: #selector(timeRepeat),
                      userInfo: nil,
                      repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }

    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func timeRepeat() {
        let currentIndex = getCurrentIndex()
        var targetIndex = currentIndex + 1
        if currentIndex == itemsCount - 1 {
            if configuration.isInfinite == false {
                return
            }
            dealLastPage()
            targetIndex = itemsCount / 2
        }
        let scrollPosition: UICollectionView.ScrollPosition = configuration.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0),
                                    at: scrollPosition,
                                    animated: true)
    }

    private func getCurrentIndex() -> Int {
        let itemWH = configuration.scrollDirection == .horizontal ? flowLayout.itemSize.width + configuration.itemSpacing : flowLayout.itemSize.height + configuration.itemSpacing
        let offsetXY = configuration.scrollDirection == .horizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        if itemWH == 0 { return 0 }
        let index = round(offsetXY / itemWH)
        return Int(index)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ELKCycleView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item % realItemsCount
        return datasource?.cycleViewConfigureCell(collectionView: collectionView,
                                                  cellForItemAt: indexPath,
                                                  realIndex: index) ?? UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let centerViewPoint = convert(collectionView.center, to: collectionView)
        guard let centerIndex = collectionView.indexPathForItem(at: centerViewPoint) else { return }
        if indexPath.item == centerIndex.item {
            let index = indexPath.item % realItemsCount
            delegate?.cycleViewDidSelectedIndex(self, index: index)
        } else {
            let scrollPosition: UICollectionView.ScrollPosition = configuration.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
            collectionView.scrollToItem(at: indexPath,
                                        at: scrollPosition,
                                        animated: true)
        }
    }
}
