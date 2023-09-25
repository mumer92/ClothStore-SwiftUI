//
//  DataService.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import Combine
import UIKit

protocol DataServiceProvider {
    func fetchData(from url: String) -> AnyPublisher<Data, ClothStoreError>
    func downloadImage(from url: String) -> AnyPublisher<UIImage, ClothStoreError>
}

class DataService: DataServiceProvider {
    private let imageCacheService: ImageCacheServiceProvider
    
    init(imageCacheService: ImageCacheService = .init()) {
        self.imageCacheService = imageCacheService
    }
}

// MARK: - Data Fetching
extension DataService {
    func fetchData(from url: String) -> AnyPublisher<Data, ClothStoreError> {
        guard let url = URL(string: url) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError(ClothStoreError.map)
            .eraseToAnyPublisher()
    }
}

// MARK: - Image Downloading
extension DataService {
    func downloadImage(from url: String) -> AnyPublisher<UIImage, ClothStoreError> {
        guard let imageURL = URL(string: url) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        if let cachedImage = imageCacheService.getImage(from: imageURL) {
            return Just(cachedImage)
                .setFailureType(to: ClothStoreError.self)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: imageURL)
            .tryMap { [weak self] response -> UIImage in
                guard let image = UIImage(data: response.data) else {
                    throw ClothStoreError.invalidImage
                }
                self?.imageCacheService.save(image, for: imageURL)
                return image
            }
            .mapError(ClothStoreError.map)
            .eraseToAnyPublisher()
    }
}
