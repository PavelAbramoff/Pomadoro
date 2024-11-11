//
//  SettingViewController.swift
//  Pomadoro
//
//  Created by apple on 11/10/24.
//
import UIKit
import AudioToolbox

class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Back-Icon"), for: .normal)
        button.addTarget(self, action: #selector (backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorPickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Timer Color"
        label.textColor = .black
        label.backgroundColor = .customBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorPicker: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        return picker
    }()
    
    let soundLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose End Sound"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let soundPicker: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Sound 1", "Sound 2", "Sound 3"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let addIntervalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Interval", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var timerColor: UIColor = .customBlue // Цвет таймера, по умолчанию
    var selectedSound: Int = 0 // Выбор звука, по умолчанию
    
    @objc func backButtonPressed() {
        self.backButton.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.backButton.alpha = 1
        })
        self.dismiss(animated: true)
    }

    // MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
       
        view.addSubview(colorPickerLabel)
        view.addSubview(soundLabel)
        view.addSubview(soundPicker)
        view.addSubview(addIntervalButton)
        view.addSubview(backButton)
        view.addSubview(settingLabel)
        
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        settingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        colorPickerLabel.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 50).isActive = true
        colorPickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        soundLabel.topAnchor.constraint(equalTo: colorPickerLabel.bottomAnchor, constant: 30).isActive = true
        soundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        soundPicker.topAnchor.constraint(equalTo: soundLabel.bottomAnchor, constant: 10).isActive = true
        soundPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        addIntervalButton.topAnchor.constraint(equalTo: soundPicker.bottomAnchor, constant: 30).isActive = true
        addIntervalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        addIntervalButton.addTarget(self, action: #selector(addIntervalButtonTapped), for: .touchUpInside)
        
        // Add gesture for color picker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showColorPicker))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc func addIntervalButtonTapped() {
        // Логика для добавления нового интервала (это можно дополнить позже)
        print("Add interval tapped")
    }
    
    @objc func showColorPicker() {
        // Открытие color picker
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    // Сохранение выбранного цвета
    func updateTimerColor(_ color: UIColor) {
        timerColor = color
        // Примените этот цвет в основном экране (например, для фона таймера)
    }
}

extension SettingsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateTimerColor(viewController.selectedColor)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        // Можно добавить дополнительные действия по завершению выбора
    }
}
