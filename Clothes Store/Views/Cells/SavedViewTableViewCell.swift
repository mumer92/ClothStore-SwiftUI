//
//  SavedViewTableViewCell.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import Combine

class SavedViewTableViewCell: UITableViewCell{

    @IBOutlet var cellView: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var addToButton: UIButton!

    weak var delegate: BuyCellButtonTapped?
    
    private var viewModel: ViewModel?
    private var product: Product?
    private var subscription: Cancellable?
    
    func configureWithProduct(product: Product, viewModel: ViewModel?) {
        self.product = product
        self.productName.text = product.name
        self.productPrice.text = CurrencyHelper.getMoneyString(product.price?.floatValue ?? 0)
        self.cellView.dropShadow(radius: 10, opacity: 0.1, color: .black)
        
        productImage.image = UIImage(systemName: "photo")
        
        subscription = viewModel?.downloadImage(url: product.image ?? "")
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] image in
                self?.productImage.image = image
            }
    }

    @IBAction func addToBasket(_ sender: Any) {
        guard let product = product else { return }
        
        delegate?.addProductToBasket(self, product: product)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subscription?.cancel()
        productImage.image = nil
    }
}
