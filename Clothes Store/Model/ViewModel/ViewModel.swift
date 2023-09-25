//
//  ViewModel.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 24/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol ViewModelProvider {
    var viewModel: ViewModel? { get set }
}

class ViewModel: ObservableObject {
    @Published var products = [Product]()
    @Published var wishListProducts = [Product]()
    @Published var basketProducts = [Product: Int]()
    @Published var isLoading = true
    @Published var isError = false
    @Published var selectedProduct: Product?
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService: DataServiceProvider
    private let coreDataService: CoreDataServiceProvider
    private let haptic: Haptic
    
    init(dataService: DataServiceProvider = DataService(), coreDataService: CoreDataServiceProvider = CoreDataService(), haptic: Haptic = .init()) {
        self.dataService = dataService
        self.coreDataService = coreDataService
        self.haptic = haptic
        fetchProducts()
    }
}

// MARK: - Product Management
extension ViewModel {
    func isProductInStock(_ product: Product) -> Bool {
        canAddProductToBasket(product: product)
    }
    
    func amountInStock(_ product: Product) -> Int {
        guard var stock = product.stock?.intValue else { return 0 }
        stock -= basketProducts[product] ?? 0
        return stock
    }
    
    func canAddProductToBasket(product: Product) -> Bool {
        amountInStock(product) > 0
    }
    
    func addToBasket(product: Product, quantity: Int = 1) {
        var count = basketProducts[product, default: 0]
        if let stock = product.stock, count < stock.intValue {
            count += quantity
            basketProducts[product] = count
            coreDataService.addProductToCart(product: product, quantity: count)
            removeProductFromWishlist(product: product)
        }
    }
    
    func downloadImage(url: String) -> AnyPublisher<UIImage, ClothStoreError>{
        return dataService.downloadImage(from: url)
    }
    
    func hapticFeedback() {
        haptic.feedBack()
    }
}

// MARK: - Data Fetching
extension ViewModel {
    func fetchProducts() {
        Publishers.Merge(coreDataService.fetchProductsFromCoreData(), fetchDataFromServer())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] products in
                self?.handleProducts(products)
            })
            .store(in: &cancellables)
    }
    
    private func fetchDataFromServer() -> AnyPublisher<[Product], ClothStoreError> {
        guard let context = CodingUserInfoKey.managedObjectContext else {
            return Fail(error: .unableToGetContext).eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.userInfo[context] = coreDataService.context
        
        return dataService.fetchData(from: URLCall.catalogue.rawValue)
            .receive(on: DispatchQueue.main)
            .decode(type: Products.self, decoder: decoder)
            .tryMap { [weak self] items -> [Product] in
                try? self?.coreDataService.context.save()
                return items.products ?? []
            }
            .mapError(ClothStoreError.map)
            .eraseToAnyPublisher()
    }
    
    private func handleProducts(_ products: [Product]) {
        self.products = products
        isLoading = products.isEmpty
        isError = products.isEmpty
        fetchWishlist()
        fetchBasket()
    }
}

// MARK: - Basket Management
extension ViewModel {
    func fetchBasket() {
        basketProducts.removeAll()
        guard let cart = coreDataService.fetchCartProducts() else { return }
        products.forEach { product in
            if let quantity = cart.first(where: { $0.productId == product.productId })?.quantity {
                addToBasket(product: product, quantity: quantity.intValue)
            }
        }
    }
    
    func removeFromBasket(product: Product) {
        basketProducts[product] = nil
        coreDataService.removeProductFromCart(product: product)
    }
    
    func calculateBasketTotal() -> Float {
        basketProducts.reduce(0) { sum, item in
            sum + (item.key.price?.floatValue ?? 0) * Float(item.value)
        }
    }
}

// MARK: - Wishlist Management
extension ViewModel {
    func fetchWishlist() {
        guard let wishlist = coreDataService.fetchWishList() else { return }
        wishListProducts = products.filter { product in
            wishlist.contains { $0.productId == product.productId }
        }
    }
    
    func updateWishlist(product: Product) {
        if wishListProducts.contains(where: { $0.productId == product.productId }) {
            removeProductFromWishlist(product: product)
        } else {
            wishListProducts.append(product)
            coreDataService.addProductToWishlist(product: product)
        }
    }
    
    func isAddedToWishlist(product: Product) -> Bool {
        wishListProducts.contains(where: { $0.productId == product.productId })
    }
    
    func removeProductFromWishlist(product: Product) {
        wishListProducts.removeAll { $0.productId == product.productId }
        coreDataService.removeProductFromWishlist(product: product)
    }
}

// MARK: - Testable Methods
extension ViewModel {
    func t_fetchDataFromServer() -> AnyPublisher<[Product], ClothStoreError> {
        fetchDataFromServer()
    }
    
    func t_handleProducts(_ products: [Product]) {
        handleProducts(products)
    }
}
