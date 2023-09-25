//
//  BasketViewTableViewCell.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import Combine

class BasketViewTableViewCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    weak var delegate : BuyCellButtonTapped?
    
    private var subscription: Cancellable?
    
    func configureWithProduct(product: Product, quantity: Int, viewModel: ViewModel?) {
        self.cellView.dropShadow(radius: 10, opacity: 0.1, color: .black)
        self.productName.text = product.name
        self.productPrice.text = CurrencyHelper.getMoneyString(product.price?.floatValue ?? 0)
        self.quantity.text = "Qty: \(quantity)"
        
        productImage.image = UIImage(systemName: "photo")
        
        subscription = viewModel?.downloadImage(url: product.image ?? "")
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

