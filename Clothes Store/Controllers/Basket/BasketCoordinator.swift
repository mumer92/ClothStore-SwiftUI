//
//  BasketCoordinator.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 05/08/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import UIKit

class BasketCoordinator: Coordinator {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    func start() -> UIViewController {
        let controller = BasketNavigationController.instantiate()
        if var viewModelProvider = controller.viewControllers.first as? ViewModelProvider {
            viewModelProvider.viewModel = viewModel
        }
        return controller
    }
}
