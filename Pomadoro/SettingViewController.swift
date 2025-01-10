//
//  SettingViewController.swift
//  Pomadoro
//
//  Created by apple on 11/10/24.
//
import UIKit
import AudioToolbox

class SettingsViewController: UIViewController, SoundSelectionDelegate {
    
    // MARK: - UI Elements
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Back-Icon"), for: .normal)
        button.addTarget(self, action: #selector (backButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.layer.cornerRadius = 20
        view.addShadowOnView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blueButton = ColorButton(color: .customBlue)
    private let greenButton = ColorButton(color: .green)
    private let blackButton = ColorButton(color: .black)
    private let orrangeButton = ColorButton(color: .orange)
    private let brownButton = ColorButton(color: .brown)
    
    private lazy var stackView = UIStackView(arrangedSubviews: [blueButton,
                                                                greenButton,
                                                                blackButton,
                                                                orrangeButton,
                                                                brownButton],
                                             
                                             axis: .horizontal,
                                             spacing: 10)
    
    let colorPickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Color"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let soundsChooseLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Sounds"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func didSelectSound(_ sound: SoundType) {
        sound.play()
        print("Сохраненный звук: \(UserDefaults.standard.string(forKey: "SelectedSound") ?? "nil")")
    }
    
    @objc func backButtonPressed() {
        self.backButton.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.backButton.alpha = 1
        })
        NotificationCenter.default.post(name: Notification.Name("SoundDidChange"), object: nil)
        self.dismiss(animated: true)
    }
    
    
   let soundSelectionView = SoundSelectionView(selectedSound: .defaultSound)
    
    // MARK: - Initial Setup
    
override func viewDidLoad() {
        super.viewDidLoad()
        soundSelectionView.delegate = self
        view.backgroundColor = .customBlue
        soundSelectionView.addShadowOnView()
        setupUI()
        setConstraints()
    }
    
    private func setupUI() {
        view.addSubview(colorPickerLabel)
        view.addSubview(buttonBackgroundView)
        view.addSubview(backButton)
        view.addSubview(settingLabel)
        view.addSubview(colorPickerLabel)
        view.addSubview(stackView)
        view.addSubview(soundsChooseLabel)
        soundSelectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(soundSelectionView)
    }
}

extension SettingsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            settingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            
            buttonBackgroundView.topAnchor.constraint(equalTo: view.topAnchor,constant: 160),
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonBackgroundView.heightAnchor.constraint(equalToConstant: 150),
            
            colorPickerLabel.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 20),
            colorPickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: buttonBackgroundView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: buttonBackgroundView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: buttonBackgroundView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            soundsChooseLabel.topAnchor.constraint(equalTo: buttonBackgroundView.bottomAnchor,constant: 20),
            soundsChooseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            soundSelectionView.topAnchor.constraint(equalTo: soundsChooseLabel.topAnchor, constant: 40),
            soundSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            soundSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            soundSelectionView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }
}
