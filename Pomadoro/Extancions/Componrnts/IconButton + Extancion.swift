//
//  Untitled.swift
//  Pomadoro
//
//  Created by apple on 1/13/25.
//

import UIKit

class IconButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(imageName: String, target: Any, action: Selector) {
        self.init(type: .system)
        configure(imageName: imageName, target: target, action: action)
    }
    
    private func configure(imageName: String, target: Any, action: Selector) {
        setImage(UIImage(named: imageName), for: .normal)
        tintColor = .white
        addTarget(target, action: action, for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
