//
//  ProductDetailTableViewController.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import Combine

class ProductDetailTableViewController: UITableViewController {
    
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productOldPrice: UILabel!
    @IBOutlet var productInStock: UILabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productCategory: UILabel!
    @IBOutlet var productStockCount: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    // MARK: - Properties
    var product: Product?
    var viewModel: ViewModel?
    var productImage: UIImage?
    private var cancellable: [AnyCancellable] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupUI()
        loadProductImage()
    }
    
    // MARK: - Setup
    private func configureTableView() {
        tableView.allowsSelection = false
    }
    
    private func setupUI() {
        guard let product = product else { return }
        setupProductName(with: product.name)
        setupProductPrice(with: product.price?.floatValue ?? 0)
        setupProductOldPrice(with: product.oldPrice)
        setupProductCategory(with: product.getCategory().rawValue)
        updateStock()
    }
    
    private func setupProductName(with name: String?) {
        productName.text = name
    }
    
    private func setupProductPrice(with price: Float) {
        productPrice.text = CurrencyHelper.getMoneyString(price)
    }
    
    private func setupProductOldPrice(with oldPrice: NSNumber?) {
        guard let oldPrice = oldPrice else {
            productOldPrice.attributedText = nil
            return
        }
        
        let priceString = CurrencyHelper.getMoneyString(oldPrice.floatValue)
        let attributedString = NSMutableAttributedString(string: priceString)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.primaryColour
        ]
        
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        productOldPrice.attributedText = attributedString
    }
    
    private func setupProductCategory(with category: String) {
        productCategory.text = category
    }
    
    // MARK: - Stock Update
    func updateStock() {
        guard let product = product else { return }
        let stockCount: Int
        let inStock: Bool
        
        if let viewModel = viewModel {
            inStock = viewModel.isProductInStock(product)
            stockCount = inStock ? viewModel.amountInStock(product) : 0
        } else {
            stockCount = product.stock?.intValue ?? 0
            inStock = stockCount > 0
        }
        
        productInStock.text = inStock ? "In Stock" : "Out of Stock"
        productStockCount.text = "\(stockCount)"
    }
    
    // MARK: - Image Loading
    private func loadProductImage() {
        guard let product = product else { return }
        productImageView.image = UIImage(systemName: "photo")
        
        viewModel?.downloadImage(url: product.image ?? "")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                self?.productImageView.image = image
            })
            .store(in: &cancellable)
    }
    
    // MARK: - TableView Delegate & DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 275 : 75
    }
}
