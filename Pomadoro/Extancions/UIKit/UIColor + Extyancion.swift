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
    static let lightBlue = #colorLiteral(red: 0.3294117647, green: 0.4901960784, blue: 0.4901960784, alpha: 1)
    static let purple = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0.9647058824, alpha: 1)
    static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let blues = #colorLiteral(red: 0.5176470588, green: 0.5019607843, blue: 0.831372549, alpha: 1)
    static let black = #colorLiteral(red: 0.07450980392, green: 0.3490196078, blue: 0.3215686275, alpha: 1)
    static let orange = #colorLiteral(red: 1, green: 0.6862745098, blue: 0.2196078431, alpha: 1)
    static let greyBlue = #colorLiteral(red: 0, green: 0.2666666667, blue: 0.4, alpha: 1)
    static let greenLight = #colorLiteral(red: 0.07058823529, green: 0.4549019608, blue: 0.3254901961, alpha: 1)
    static let whiteLight = #colorLiteral(red: 0.9137254902, green: 0.9215686275, blue: 0.9058823529, alpha: 1)
    static let greenGrad = #colorLiteral(red: 0.9137254902, green: 0.9215686275, blue: 0.9058823529, alpha: 1)
    static let orangeRed = #colorLiteral(red: 0.9294117647, green: 0.2941176471, blue: 0, alpha: 1)
    
    static var customColor: UIColor {
        get {
            if let colorData = UserDefaults.standard.data(forKey: "customColor"),
               let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                return color
            }
            return .customBlue
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
