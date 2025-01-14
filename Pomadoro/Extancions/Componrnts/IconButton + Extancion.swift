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
    
    /// Удобный инициализатор для создания кнопки с изображением и действием
    /// - Parameters:
    ///   - imageName: Имя изображения для кнопки
    ///   - target: Цель, на которую направлено действие
    ///   - action: Селектор действия
    convenience init(imageName: String, target: Any, action: Selector) {
        self.init(type: .system)
        configure(imageName: imageName, target: target, action: action)
    }
    
    /// Конфигурация кнопки
    /// - Parameters:
    ///   - imageName: Имя изображения
    ///   - target: Цель
    ///   - action: Селектор действия
    private func configure(imageName: String, target: Any, action: Selector) {
        setImage(UIImage(named: imageName), for: .normal)
        tintColor = .white
        addTarget(target, action: action, for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
