//
//  TableView+Extension.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 05/08/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(with type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    func dequeueCell<T: UITableViewCell>(with type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
