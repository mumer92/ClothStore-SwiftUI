//
//  WishlistViewController.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import Combine

protocol BuyCellButtonTapped: AnyObject {
    func addProductToBasket(_ sender: SavedViewTableViewCell, product: Product)
}

class WishlistViewController: UIViewController, StoryboardAdoptable, BuyCellButtonTapped, ViewModelProvider {
    
    static var storyboard: StoryboardName {
        return .wishlist
    }
    
    //Views
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noProductsLabel: UILabel!
    
    //Variables
    private var products: [Product] = []
    private var cancellable: AnyCancellable?
    
    var viewModel: ViewModel? {
        didSet {
            cancellable = viewModel?.$wishListProducts
                .sink { [weak self] products in
                    self?.products = products
                    self?.tableView?.reloadData()
                    self?.noProductsLabel?.isHidden = !products.isEmpty
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        noProductsLabel.isHidden = !products.isEmpty
    }
    
    // MARK: - Actions
    func addProductToBasket(_ sender: SavedViewTableViewCell, product: Product) {
        guard let viewModel = viewModel else { return }

        if viewModel.canAddProductToBasket(product: product) {
            viewModel.addToBasket(product: product)
            viewModel.hapticFeedback()
        } else {
            showError(name: product.name ?? "")
        }
    }
    
    func showError(name: String) {
        let alert = UIAlertController(title: "Out of stock", message: "\(name.capitalized) is out of stock", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension WishlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: SavedViewTableViewCell.self, for: indexPath) as? SavedViewTableViewCell else {
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.delegate = self
        cell.configureWithProduct(product: product, viewModel: viewModel)        
        return cell
    }
}

extension WishlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, _ in
            guard let weakSelf = self else { return }
            
            let product = weakSelf.products[indexPath.row]
            weakSelf.viewModel?.removeProductFromWishlist(product: product)
            weakSelf.viewModel?.hapticFeedback()
        }
        
        deleteAction.backgroundColor = .primaryColour
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
}


