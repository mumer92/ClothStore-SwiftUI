//
//  MockCoreDataService.swift
//  ClothesStoreTests
//
//  Created by MuhammadUmer on 9/25/22.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import Foundation
import Combine
import CoreData
@testable import ClothesStore

class MockCoreDataService: CoreDataServiceProvider {
    var context: NSManagedObjectContext
    var shouldReturnError = false
    var mockProducts: [Product] = []
    var mockWishlist: [Wishlist] = []
    var mockCartProducts: [Cart] = []
    
    init() {
        let coreDataStack = CoreDataStack(inMemory: true, modelName: "ClothesStore")
        self.context = coreDataStack.context
    }
    
    func fetchProductsFromCoreData() -> AnyPublisher<[Product], ClothStoreError> {
        if shouldReturnError {
            return Fail(error: .custom("Mocked Error")).eraseToAnyPublisher()
        }
        
        return Just(mockProducts)
            .setFailureType(to: ClothStoreError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchProduct(with productId: String) -> Product? {
        return mockProducts.first { $0.productId == productId }
    }
    
    func fetchProducts() -> [Product]? {
        return shouldReturnError ? nil : mockProducts
    }
    
    func fetchWishList() -> [Wishlist]? {
        return shouldReturnError ? nil : mockWishlist
    }
    
    func addProductToWishlist(product: Product) {
        if !shouldReturnError {
            let wishlistItem = Wishlist(context: self.context)
            wishlistItem.productId = product.productId
            mockWishlist.append(wishlistItem)
        }
    }
    
    func removeProductFromWishlist(product: Product) {
        if !shouldReturnError {
            mockWishlist.removeAll { $0.productId == product.productId }
        }
    }
    
    func fetchCartProducts() -> [Cart]? {
        return shouldReturnError ? nil : mockCartProducts
    }
    
    func addProductToCart(product: Product, quantity: Int = 1) {
        if !shouldReturnError {
            let cartItem = Cart(context: self.context)
            cartItem.productId = product.productId
            cartItem.quantity = NSNumber(value: quantity)
            mockCartProducts.append(cartItem)
        }
    }
    
    func removeProductFromCart(product: Product) {
        if !shouldReturnError {
            mockCartProducts.removeAll { $0.productId == product.productId }
        }
    }
    
    func removeProducts() {
        if !shouldReturnError {
            mockProducts.removeAll()
        }
    }
}
