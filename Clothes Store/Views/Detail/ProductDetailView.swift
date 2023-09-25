//
//  ProductDetailView.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 25/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import SwiftUI
import UIKit

struct ProductDetailView: UIViewControllerRepresentable {
    let viewModel: ViewModel
    let product: Product
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let detailViewController = DetailViewContainerViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: detailViewController)
        detailViewController.viewModel = viewModel
        detailViewController.product = product
        return navigationController
    }
}
