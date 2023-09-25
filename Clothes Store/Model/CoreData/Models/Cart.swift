//
//  Cart.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 31/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import Foundation
import CoreData

class Cart: NSManagedObject {
    class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: Cart.entityName)
    }

    @NSManaged var productId: String?
    @NSManaged var quantity: NSNumber?
}

