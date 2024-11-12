//
//  ColorButton.swift
//  Pomadoro
//
//  Created by apple on 11/11/24.
//

import UIKit

class ColorButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor) {
        self.init(type: .system)
        configuure(color: color)
    }
    
    private func configuure(color: UIColor) {
        layer.cornerRadius = 30
        backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
        
        addShadowOnView()
    }
}
