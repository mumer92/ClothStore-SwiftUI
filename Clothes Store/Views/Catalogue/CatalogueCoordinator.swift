//
//  CatalogueCoordinator.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 05/08/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import UIKit
import SwiftUI

class CatalogueCoordinator: Coordinator {
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func start() -> UIViewController {
        let controller = UIHostingController(rootView: CatalogueListView(viewModel: self.viewModel))
        controller.tabBarItem.image = UIImage(systemName: "list.dash")
        controller.tabBarItem.title = "Catalogue"
        return controller
    }
}
