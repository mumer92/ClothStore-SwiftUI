//
//  ClothStoreError.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 05/08/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import Foundation

enum ClothStoreError: Error {
    case statusCode
    case decoding
    case invalidImage
    case invalidURL
    case unableToGetContext
    case noLocallyCachedProducts
    case other(Error)
    case custom(String)
    
    static func map(_ error: Error) -> ClothStoreError {
        return error as? ClothStoreError ?? .other(error)
    }
}
