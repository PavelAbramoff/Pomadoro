//
//  UIDatePicker + Extancion.swift
//  Pomadoro
//
//  Created by apple on 1/13/25.
//

import UIKit

class DatePickerConfigurator: UIDatePicker {

    convenience init(duration: Int, backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.2)) {
        self.init()
        setupPicker(duration: duration, backgroundColor: backgroundColor)
    }

    private func setupPicker(duration: Int, backgroundColor: UIColor) {
        self.datePickerMode = .countDownTimer
        self.tintColor = .white
        self.preferredDatePickerStyle = .automatic
        self.backgroundColor = backgroundColor
        self.countDownDuration = TimeInterval(duration)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

