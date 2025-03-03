//
//  UIView + Extancion.swift
//  Pomadoro
//
//  Created by apple on 2/15/25.
//

import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        self.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.0) // Начало сверху
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Конец снизу
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
