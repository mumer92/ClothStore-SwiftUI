//
//  HUD.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit

class AnimateMe {
    class func animateLabel(_ label: UIView) {
        let viewOriginalPosition = CGRect(x: label.frame.minX, y: label.frame.minY, width: label.frame.width, height: label.frame.height)
        UIView.animate(withDuration: 0.75, delay: 0, options: [.curveEaseOut]) {
            label.frame = CGRect(x: label.frame.minX, y: label.frame.minY + 65, width: label.frame.width, height: label.frame.height)
            label.alpha = 0
        } completion: { _ in
            label.frame = viewOriginalPosition
            label.alpha = 1
        }
    }
}
