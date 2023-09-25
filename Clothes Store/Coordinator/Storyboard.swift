//
//  Storyboard.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 24/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import UIKit

enum StoryboardName: String, StringConvertible {
    case main = "Main"
    case wishlist = "WishlistStoryboard"
    case basket = "BasketStoryboard"
    case detail = "DetailStoryboard"
}

protocol StoryboardAdoptable {
    static var storyboard: StoryboardName { get }
    static func instantiate() -> Self
}

extension StoryboardAdoptable where Self: UIViewController {
    static var storyboard: StoryboardName {
        return .main
    }
    
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

protocol StringConvertible {
    var rawValue: String { get }
}

extension String: StringConvertible {
    var rawValue: String {
        return self
    }
}
