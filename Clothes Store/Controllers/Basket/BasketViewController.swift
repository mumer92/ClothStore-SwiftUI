//
//  BasketViewController.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import Combine

class BasketViewController: UIViewController, ViewModelProvider, StoryboardAdoptable {
    
    static var storyboard: StoryboardName {
        return .basket
    }
    
    //Views
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noProductsLabel: UILabel!
    @IBOutlet var total: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
    @IBAction func didTapCheckout(_ sender: Any) {
        
    }
    
    //Variables
    private var products: [Product : Int] = [:]
    private var cancellable: AnyCancellable?
    
    var viewModel: ViewModel? {
        didSet {
            cancellable = viewModel?.$basketProducts
                .sink { [weak self] products in
                    self?.products = products
                    self?.tableView?.reloadData()
                    self?.noProductsLabel?.isHidden = !products.isEmpty
                    self?.total?.text = CurrencyHelper.getMoneyString(self?.viewModel?.calculateBasketTotal() ?? 0)
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        checkoutButton.dropShadow(radius: 8, opacity: 0.4, color: .primaryColour)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noProductsLabel.isHidden = !products.isEmpty
        total.text = CurrencyHelper.getMoneyString(viewModel?.calculateBasketTotal() ?? 0)
    }
    
    func updateViews() {
        tableView.reloadData()
        total.text = CurrencyHelper.getMoneyString(viewModel?.calculateBasketTotal() ?? 0)
    }
}

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: BasketViewTableViewCell.self, for: indexPath) as? BasketViewTableViewCell else {
            return UITableViewCell()
        }
        
        let item = products[indexPath.row]
        cell.configureWithProduct(product: item.key, quantity: item.value, viewModel: viewModel)        
        return cell
    }
}

extension BasketViewController: UITableViewDelegate {
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
            
            let item = weakSelf.products[indexPath.row]
            weakSelf.viewModel?.removeFromBasket(product: item.key)
            weakSelf.viewModel?.hapticFeedback()
            weakSelf.updateViews()
        }
        
        deleteAction.backgroundColor = .primaryColour
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
        
    }
}

fileprivate extension Dictionary {
    subscript(offset: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: offset)]
    }
}
