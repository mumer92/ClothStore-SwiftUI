//
//  CurrencyHelpers.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import Foundation

class CurrencyHelper {
    
    class func getMoneyString(_ value: Float) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = .current
        return currencyFormatter.string(from: NSNumber(value: value)) ?? "0"
    }
}
