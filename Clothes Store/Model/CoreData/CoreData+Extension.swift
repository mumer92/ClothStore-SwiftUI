//
//  CoreData+Extension.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 03/08/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import CoreData

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

extension NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}
