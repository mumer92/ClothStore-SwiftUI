//
//  MockDataService.swift
//  ClothesStoreTests
//
//  Created by MuhammadUmer on 9/25/22.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import Foundation
import Combine
import UIKit
@testable import ClothesStore

class MockDataService: DataServiceProvider {
    var shouldReturnError = false
    var fetchedData: Data?
    var downloadedImage: UIImage?
    
    init() { }
    
    func fetchData(from url: String) -> AnyPublisher<Data, ClothStoreError> {
        if shouldReturnError {
            return Fail(error: .custom("Mocked Error")).eraseToAnyPublisher()
        }
        
        if let data = fetchedData {
            return Just(data)
                .setFailureType(to: ClothStoreError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: .custom("No Mock Data")).eraseToAnyPublisher()
    }
    
    func downloadImage(from url: String) -> AnyPublisher<UIImage, ClothStoreError> {
        if shouldReturnError {
            return Fail(error: .custom("Mocked Error")).eraseToAnyPublisher()
        }
        
        if let image = downloadedImage {
            return Just(image)
                .setFailureType(to: ClothStoreError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: .custom("No Mock Image")).eraseToAnyPublisher()
    }
}
