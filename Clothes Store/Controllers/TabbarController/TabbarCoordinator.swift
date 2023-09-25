//
//  TabbarCoordinator.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 05/08/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import UIKit
import SwiftUI

class ApplicationCoordinator: Coordinator {
    
    private let viewModel = ViewModel()
    private let window: UIWindow
    private let rootViewController: UITabBarController
    
    private lazy var catalogueCoordinator: CatalogueCoordinator = {
        let coordinator = CatalogueCoordinator(viewModel: self.viewModel)
        return coordinator
    }()
    
    private lazy var wishlistCoordinator: WishlistCoordinator = {
        let coordinator = WishlistCoordinator(viewModel: self.viewModel)
        return coordinator
    }()
    
    private lazy var basketCoordinator: BasketCoordinator = {
        let coordinator = BasketCoordinator(viewModel: self.viewModel)
        return coordinator
    }()
        
    init(window: UIWindow) {
        self.window = window
        let controller = TabBarController.instantiate()
        controller.viewModel = viewModel
        self.rootViewController = controller
    }
    
    @discardableResult
    func start() -> UIViewController {
        setup()
        makeRootView()
        return rootViewController
    }
    
    private func setup() {
        rootViewController.viewControllers = [
            catalogueCoordinator.start(),
            wishlistCoordinator.start(),
            basketCoordinator.start()
        ]
    }
    
    private func makeRootView() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
