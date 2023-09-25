//
//  Wishlist.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 31/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import Foundation
import CoreData

class Wishlist: NSManagedObject {
    class func fetchRequest() -> NSFetchRequest<Wishlist> {
        return NSFetchRequest<Wishlist>(entityName: entityName)
    }

    @NSManaged var productId: String?
}
