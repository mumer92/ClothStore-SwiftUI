//
//  DetailViewContainerViewController.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit

class DetailViewContainerViewController: UIViewController, StoryboardAdoptable {

    static var storyboard: StoryboardName {
        return .detail
    }
    
    var backButton: UIBarButtonItem!
    @IBOutlet var wishListButton: UIButton!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var addedToWishlistLabel: UILabel!
    @IBOutlet var addedToBasketLabel: UILabel!

    var product: Product?
    var viewModel: ViewModel?
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCartAction(_ sender: Any) {
        guard let product = product, let viewModel = viewModel else {
            return
        }
        if viewModel.canAddProductToBasket(product: product) {
            viewModel.addToBasket(product: product)
            viewModel.hapticFeedback()
            let title = "Added to basket"
            let message = "\(product.name ?? "") is added to basket"
            showAlert(title: title, message: message, buttonTitle: "Okay")
            
            if let detailViewController = children.first as? ProductDetailTableViewController {
                detailViewController.updateStock()
            }
        } else {
            viewModel.hapticFeedback()
            let title = "Out of stock"
            let message = "\(product.name ?? "") is out of stock"
            showAlert(title: title, message: message, buttonTitle: "Okay")
        }
    }

    @IBAction func addToWishListAction(_ sender: Any) {
        guard let product = product, let viewModel = viewModel else { return }
        if !viewModel.isAddedToWishlist(product: product) {
            viewModel.updateWishlist(product: product)
            let title = "Added to wishlist"
            let message = "\(product.name ?? "") is added to wishlist"
            showAlert(title: title, message: message, buttonTitle: "Okay")
        } else {
            viewModel.hapticFeedback()
            let title = "Already added to wishlist"
            let message = "\(product.name ?? "") is already added to wishlist"
            showAlert(title: title, message: message, buttonTitle: "Okay")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtons()
    }
    
    private func setUpButtons() {
        wishListButton.dropShadow(radius: 8, opacity: 0.2, color: .black)
        addToCartButton.dropShadow(radius: 8, opacity: 0.4, color: .primaryColour)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueProductDetailTableViewController",
            let destination = segue.destination as? ProductDetailTableViewController {
            destination.viewModel = viewModel
            destination.product = product
        }
    }
    
    private func showAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}
