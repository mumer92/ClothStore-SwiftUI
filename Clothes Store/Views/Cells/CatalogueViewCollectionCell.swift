//
//  CatalogueViewCollectionCell.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import Combine

class CatalogueViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet var wishListed: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    
    private var subscription: Cancellable?
    
    func configureWithProduct(product: Product, viewModel: ViewModel) {
        self.productName.text = product.name
        self.productPrice.text = CurrencyHelper.getMoneyString(product.price?.floatValue ?? 0)
        self.cellView.dropShadow(radius: 10, opacity: 0.1, color: .black)
                
        productImage.image = UIImage(systemName: "photo")
        
        subscription = viewModel.downloadImage(url: product.image ?? "")
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] image in
                self?.productImage.image = image
            }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subscription?.cancel()
        productImage.image = nil
    }
}


