//
//  UIStackView.swift
//  Pomadoro
//
//  Created by apple on 11/11/24.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
