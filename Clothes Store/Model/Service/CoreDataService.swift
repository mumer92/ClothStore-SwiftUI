//
//  CoreDataService.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 29/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import UIKit
import CoreData
import Combine

protocol CoreDataServiceProvider {
    var context: NSManagedObjectContext { get }
    func fetchProductsFromCoreData() -> AnyPublisher<[Product], ClothStoreError>
    func fetchProduct(with productId: String) -> Product?
    func fetchProducts() -> [Product]?
    func fetchWishList() -> [Wishlist]?
    func addProductToWishlist(product: Product)
    func removeProductFromWishlist(product: Product)
    func fetchCartProducts() -> [Cart]?
    func addProductToCart(product: Product, quantity: Int)
    func removeProductFromCart(product: Product)
    func removeProducts()
}

class CoreDataService: CoreDataServiceProvider {
    let context: NSManagedObjectContext
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Failed to retrieve AppDelegate")
        }
        self.context = appDelegate.coreDataStack.context
    }
    
    func fetchProductsFromCoreData() -> AnyPublisher<[Product], ClothStoreError> {
        Just(fetchProducts() ?? [])
            .setFailureType(to: ClothStoreError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchProduct(with productId: String) -> Product? {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId = %@", productId)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching product with id \(productId): \(error)")
            return nil
        }
    }
    
    func fetchProducts() -> [Product]? {
        performFetch(for: Product.fetchRequest())
    }
    
    func fetchWishList() -> [Wishlist]? {
        performFetch(for: Wishlist.fetchRequest())
    }
    
    func addProductToWishlist(product: Product) {
        guard let productID = product.productId else { return }
        let wishlistItem = Wishlist(context: context)
        wishlistItem.productId = productID
        saveContext()
    }
    
    func removeProductFromWishlist(product: Product) {
        removeEntity(Wishlist.entityName, with: product.productId)
    }
    
    func fetchCartProducts() -> [Cart]? {
        performFetch(for: Cart.fetchRequest())
    }
    
    func addProductToCart(product: Product, quantity: Int = 1) {
        guard let productID = product.productId else { return }
        
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId = %@", productID)
        
        do {
            let cart = try context.fetch(fetchRequest).first ?? Cart(context: context)
            cart.productId = productID
            cart.quantity = NSNumber(value: quantity)
            saveContext()
        } catch let error {
            print(error)
        }
    }
    
    func removeProductFromCart(product: Product) {
        removeEntity(Cart.entityName, with: product.productId)
    }
    
    func removeProducts() {
        removeEntity(Product.entityName)
    }
}

// MARK: - Private Helpers
private extension CoreDataService {
    func performFetch<T>(for request: NSFetchRequest<T>) -> [T]? where T: NSManagedObject {
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching: \(error)")
            return nil
        }
    }
    
    func removeEntity(_ entityName: String, with productID: String? = nil) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let productID = productID {
            fetch.predicate = NSPredicate(format: "productId = %@", productID)
        }
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
        } catch let error {
            print(error)
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch let error {
            print("Error saving context: \(error)")
        }
    }
}
