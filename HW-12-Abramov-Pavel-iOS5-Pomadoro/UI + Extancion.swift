//
//  UI + Extancion.swift
//  HW-12-Abramov-Pavel-iOS5-Pomadoro
//
//  Created by apple on 11/4/24.
//
import UIKit

extension UIView {
    
    func addShadowOnView() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1
    }
}
