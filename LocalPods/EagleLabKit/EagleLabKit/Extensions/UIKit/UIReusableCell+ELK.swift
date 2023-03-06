//
//  UIReusableCell+ELK
//  TCLHome
//
//  Created by lidan on 2022/1/14.
//  Copyright © 2022 TCL Eagle Lab. All rights reserved.
//

import UIKit

extension EagleLabKit where Base: UITableView {
    func registerCell<T: UITableViewCell>(withType type: T.Type) {
        let typename = String(describing: type)
        return base.register(NSClassFromString(typename), forCellReuseIdentifier: typename)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(withType type: T.Type) {
        let typename = String(describing: type)
        return base.register(NSClassFromString(typename), forHeaderFooterViewReuseIdentifier: typename)
    }

    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type) -> T? {
        return base.dequeueReusableCell(withIdentifier: String(describing: type)) as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T? {
        return base.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withType type: T.Type) -> T? {
        return base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as? T
    }
}

extension EagleLabKit where Base: UITableViewCell {
    static func create(style: UITableViewCell.CellStyle = .default) -> Base {
        return Base(style: style, reuseIdentifier: String(describing: Base.self))
    }
}

extension EagleLabKit where Base: UITableViewHeaderFooterView {
    static func create() -> Base {
        return Base(reuseIdentifier: String(describing: Base.self))
    }
}

extension EagleLabKit where Base: UICollectionView {
    func registerCell<T: UICollectionViewCell>(withType type: T.Type) {
        let typename = String(describing: type)
        base.register(type.self, forCellWithReuseIdentifier: typename)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T? {
        return base.dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T
    }

    func dequeueReusableSupplementaryView<T: UICollectionViewCell>(ofKind elementKind: String, withType type: T.Type, for indexPath: IndexPath) -> T? {
        return base.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: String(describing: type), for: indexPath) as? T
    }
}
