//
//  SelectorDialogElement.swift
//  TCLHome
//
//  Created by huaizhang.chen on 2022/2/18.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import Foundation
import UIKit

class SelectorDialogElement: BasicDialogElement {
    static let minimalCellHeight: CGFloat = 48.0

    typealias ResultFromItemTapBlock = (_ selectedItems: [SelectorDialogItem], _ selectedIndexes: [Int]) -> Void

    public var resultBlock: ResultFromItemTapBlock?

    var selectedIndexes: [Int] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.elk.registerCell(withType: DialogSelectorCell.self)
        return tableView
    }()

    public func selectedItems() -> [SelectorDialogItem] {
        if let selectorModel = model as? SelectorDialogModel {
            var items: [SelectorDialogItem] = []
            for number in selectedIndexes {
                items.append(selectorModel.items[number])
            }
            return items
        } else {
            return []
        }
    }

    override func setUpDetailDialogElement() {
        super.setUpDetailDialogElement()
        if let selectorModel = model as? SelectorDialogModel {
            layoutSelectorElement(selectorModel: selectorModel)
        }
    }

    private func layoutSelectorElement(selectorModel: SelectorDialogModel) {
        tableView.frame = bounds
        addSubview(tableView)
    }

    override class func elementHeight(model: BasicDialogModel, elementWidth: CGFloat) -> CGFloat {
        if let selectorModel = model as? SelectorDialogModel {
            let cellNumShown: Int = selectorModel.items.count < selectorModel.preference.maxShownItemNum ? selectorModel.items.count : selectorModel.preference.maxShownItemNum
            return CGFloat(cellNumShown) * minimalCellHeight
        } else {
            return 0.0
        }
    }
}

extension SelectorDialogElement: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectorModel = model as? SelectorDialogModel {
            return selectorModel.items.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let selectorModel = model as? SelectorDialogModel {
            let cell = tableView.elk.dequeueReusableCell(withType: DialogSelectorCell.self) ?? DialogSelectorCell.elk.create()

            let cellItem: SelectorDialogItem = selectorModel.items[indexPath.row]
            cell.item = cellItem
            cell.makeUnderline(show: indexPath.row != selectorModel.items.count - 1)

            if cellItem.preference.maxSelectNum == 1, cellItem.preference.resultFromItemTap, cellItem.enabled {
                cell.selectionStyle = UITableViewCell.SelectionStyle.default
            } else {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            }

            return cell
        } else {
            return DialogSelectorCell.elk.create()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectorModel = model as? SelectorDialogModel {
            let cellItem: SelectorDialogItem = selectorModel.items[indexPath.row]

            if !cellItem.enabled {
                return
            }

            if selectedIndexes.contains(indexPath.row) {
                cellItem.selected = false
                selectedIndexes.remove(at: indexPath.row)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            } else if selectorModel.preference.maxSelectNum > 1 {
                if selectedIndexes.count < selectorModel.preference.maxSelectNum {
                    cellItem.selected = true
                    selectedIndexes.append(indexPath.row)
                    self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                }
            } else if selectorModel.preference.maxSelectNum == 1 {
                if selectedIndexes.count == 1 {
                    cellItem.selected = true
                    let oldIndexPath: IndexPath = .init(row: selectedIndexes[0], section: 0)
                    let oldItem: SelectorDialogItem = selectorModel.items[oldIndexPath.row]
                    oldItem.selected = false
                    self.tableView.reloadRows(at: [indexPath, oldIndexPath], with: UITableView.RowAnimation.none)

                    selectedIndexes.removeAll()
                    selectedIndexes.append(indexPath.row)
                } else {
                    cellItem.selected = true
                    self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                    selectedIndexes.append(indexPath.row)

                    if let block = resultBlock, selectorModel.preference.resultFromItemTap {
                        block(selectedItems(), selectedIndexes)
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectorDialogElement.minimalCellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
