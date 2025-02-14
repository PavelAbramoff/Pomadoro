//
//  UIColor + Extyancion.swift
//  Pomadoro
//
//  Created by apple on 11/10/24.
//

import UIKit

extension UIColor {
    static let customBlue = #colorLiteral(red: 0.003921568627, green: 0.4588235294, blue: 0.8901960784, alpha: 1)
    static let customGreen = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    static let lightBlue = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
    static let purple = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0.9647058824, alpha: 1)
    static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let blues = #colorLiteral(red: 0.5176470588, green: 0.5019607843, blue: 0.831372549, alpha: 1)
    static let black = #colorLiteral(red: 0.137254902, green: 0.1607843137, blue: 0.2745098039, alpha: 1)
    static let greyBlue = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    static let customGrey = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    
    static var customColor: UIColor {
            get {
                if let colorData = UserDefaults.standard.data(forKey: "customColor"),
                   let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                    return color
                }
                return .customBlue // Цвет по умолчанию
            }
            set {
                if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) {
                    UserDefaults.standard.set(colorData, forKey: "customColor")
                }
                NotificationCenter.default.post(name: .customColorDidChange, object: nil)
            }
        }

        static func updateCustomColor(to color: UIColor) {
            customColor = color
        }
}

extension Notification.Name {
    static let customColorDidChange = Notification.Name("customColorDidChange")
}
