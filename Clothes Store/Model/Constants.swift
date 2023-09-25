//
//  Constants.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum URLCall : String {
    case catalogue = "https://api.npoint.io/0f78766a6d68832d309d"
}

extension UIColor {
    class var primaryColour: UIColor {
        return #colorLiteral(red: 1, green: 0.3333333333, blue: 0.4039215686, alpha: 1)
    }
}

extension Color {
    static let primaryColour = Color(uiColor: .primaryColour)
}
