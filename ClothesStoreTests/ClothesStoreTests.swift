//
//  ClothesStoreTests.swift
//  ClothesStoreTests
//
//  Created by MuhammadUmer on 05/08/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import XCTest
import Combine
@testable import ClothesStore

class ClothesStoreTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var mockCoreDataService: MockCoreDataService!
    private var mockDataService: MockDataService!
    private var viewModel: ViewModel!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockCoreDataService = MockCoreDataService()
        mockDataService = MockDataService()
        viewModel = ViewModel(dataService: mockDataService, coreDataService: mockCoreDataService)
    }
    
    func testFetchProductsFromCoreData() {
        let expectation = self.expectation(description: "FetchProductsFromCoreData")
        let mockProduct = Product(context: mockCoreDataService.context)
        mockCoreDataService.mockProducts = [mockProduct]
        
        viewModel.fetchProducts()
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.products.count, 1)
            XCTAssertEqual(self.viewModel.products.first, mockProduct)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testAddToBasket() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.stock = NSNumber(value: 5)
        
        viewModel.addToBasket(product: mockProduct)
        
        XCTAssertEqual(viewModel.basketProducts[mockProduct], 1)
    }
    
    func testRemoveFromBasket() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.stock = NSNumber(value: 5)
        
        viewModel.addToBasket(product: mockProduct)
        viewModel.removeFromBasket(product: mockProduct)
        
        XCTAssertNil(viewModel.basketProducts[mockProduct])
    }
    
    func testCalculateBasketTotal() {
        let mockProduct1 = Product(context: mockCoreDataService.context)
        mockProduct1.price = NSNumber(value: 10.0)
        mockProduct1.stock = NSNumber(value: 5) // Ensure stock is set
        
        let mockProduct2 = Product(context: mockCoreDataService.context)
        mockProduct2.price = NSNumber(value: 20.0)
        mockProduct2.stock = NSNumber(value: 5) // Ensure stock is set
        
        viewModel.addToBasket(product: mockProduct1, quantity: 2)
        viewModel.addToBasket(product: mockProduct2, quantity: 3)
        
        let total = viewModel.calculateBasketTotal()
        
        XCTAssertEqual(total, 80.0)
    }
    
    func testUpdateWishlist() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.productId = "mockProductID"
        viewModel.updateWishlist(product: mockProduct)
        
        XCTAssertTrue(viewModel.isAddedToWishlist(product: mockProduct))
    }
    
    func testRemoveProductFromWishlist() {
        let mockProduct = Product(context: mockCoreDataService.context)
        viewModel.updateWishlist(product: mockProduct)
        viewModel.removeProductFromWishlist(product: mockProduct)
        
        XCTAssertFalse(viewModel.isAddedToWishlist(product: mockProduct))
    }
    
    func testFetchProductsFromServerError() {
        let expectation = expectation(description: "ProductsFromServerError")
        
        mockCoreDataService.shouldReturnError = true
        
        var error: ClothStoreError?
        
        viewModel.t_fetchDataFromServer()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    error = err
                }
                expectation.fulfill()
            } receiveValue: { _ in
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
        
        XCTAssertNotNil(error)
    }

    func testIsProductInStock() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.stock = 5
        
        XCTAssertTrue(viewModel.isProductInStock(mockProduct))
    }
    
    func testIsProductOutOfStock() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.stock = 0
        
        XCTAssertFalse(viewModel.isProductInStock(mockProduct))
    }

    
    func testAmountInStock() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.stock = 5
        
        XCTAssertEqual(viewModel.amountInStock(mockProduct), 5)
    }

    func testCanAddProductToBasket() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.stock = 5
        
        XCTAssertTrue(viewModel.canAddProductToBasket(product: mockProduct))
    }

    func testCannotAddProductToBasket() {
        let mockProduct = Product(context: mockCoreDataService.context)
        mockProduct.stock = 0
        
        XCTAssertFalse(viewModel.canAddProductToBasket(product: mockProduct))
    }
}
