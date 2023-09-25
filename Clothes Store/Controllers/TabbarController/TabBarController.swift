//
//  TabBarController.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class TabBarController: UITabBarController, StoryboardAdoptable {
        
    //Variables
    var viewModel: ViewModel?
    
    private var cancellables: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWishListObserver()
        addBasketObserver()
    }
    
    func addWishListObserver() {
        viewModel?.$wishListProducts
            .sink { [weak self] products in
                self?.updateWishListBadge(count: products.count)
            }.store(in: &cancellables)
    }
    
    func addBasketObserver() {
        viewModel?.$basketProducts
            .sink { [weak self] products in
                self?.updateBasketBadge(count: products.count)
            }.store(in: &cancellables)
    }
    
    func updateWishListBadge(count: Int) {
        guard let tabItems = tabBar.items else { return }
        let badge = tabItems[1]
        badge.badgeValue = count > 0 ? "\(count)" : nil
    }
    
    func updateBasketBadge(count: Int) {
        guard let tabItems = tabBar.items else { return }
        let badge = tabItems[2]
        badge.badgeValue = count > 0 ? "\(count)" : nil
    }
}
