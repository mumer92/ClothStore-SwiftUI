//
//  ImageCacheService.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 28/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import UIKit

protocol ImageCacheServiceProvider {
    func getImage(from url: URL) -> UIImage?
    func save(_ image: UIImage, for url: URL)
}

class ImageCacheService: ImageCacheServiceProvider {
    
    private var documentsDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func getImage(from url: URL) -> UIImage? {
        guard let imageURL = cachedImageURL(for: url) else { return nil }
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    func save(_ image: UIImage, for url: URL) {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let filename = cachedImageURL(for: url) else { return }
        do {
            try data.write(to: filename)
        } catch {
            print("Error saving image: \(error)")
        }
    }
}

// MARK: - Private Helpers
private extension ImageCacheService {
    func cachedImageURL(for url: URL) -> URL? {
        documentsDirectory?.appendingPathComponent(url.lastPathComponent)
    }
}
