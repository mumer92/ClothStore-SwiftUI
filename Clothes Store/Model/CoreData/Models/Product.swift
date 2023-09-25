//
//  Product
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Products
struct Products: Codable {
    var products: [Product]?
}

class Product: NSManagedObject, Codable, Identifiable {
    class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: Product.entityName)
    }
            
    var id: String {
        return productId ?? UUID().uuidString
    }
    
    @NSManaged var productId: String?
    @NSManaged var name: String?
    @NSManaged var category: String?
    @NSManaged var price: NSNumber?
    @NSManaged var stock: NSNumber?
    @NSManaged var oldPrice: NSNumber?
    @NSManaged var image: String?
    
    @NSManaged var cart: Cart?
    @NSManaged var wishlist: Wishlist?
    
    enum CodingKeys: String, CodingKey {
        case productId, name, category, price, stock, oldPrice, image
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: Product.entityName, in: managedObjectContext) else {
            fatalError("Failed to decode Product")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)

        if let price = try? container.decode(Float.self, forKey: .price) {
            self.price = NSNumber(value: price)
        }
        
        if let oldPrice = try? container.decode(Float.self, forKey: .oldPrice) {
            self.oldPrice = NSNumber(value: oldPrice)
        }
        
        if let stock = try? container.decode(Int.self, forKey: .stock) {
            self.stock = NSNumber(value: stock)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productId, forKey: .productId)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encodeIfPresent(price?.floatValue, forKey: .price)
        try container.encodeIfPresent(oldPrice?.floatValue, forKey: .price)
        try container.encodeIfPresent(stock?.intValue, forKey: .stock)
        try container.encode(image, forKey: .image)
    }
    
    func getCategory() -> Category {
        return Category.get(from: category ?? "")
    }
}

enum Category: String, Codable, CaseIterable {
    case unknown = "Unknown"
    case pants = "Pants"
    case shoes = "Shoes"
    case tops = "Tops"
    
    static func get(from: String) -> Category {
        for category in Category.allCases {
            if from == category.rawValue {
                return category
            }
        }
        return .unknown
    }
}
