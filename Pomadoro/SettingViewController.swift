//
//  SettingViewController.swift
//  Pomadoro
//
//  Created by apple on 11/10/24.
//
import UIKit
import AudioToolbox

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateTotalCycles(_ totalCycles: Int)
}

class SettingsViewController: UIViewController, SoundSelectionDelegate {
    
    
    // MARK: - Properties
    weak var delegate: SettingsViewControllerDelegate?
    var totalCycles: Int {
        get {
            let cycles = UserDefaults.standard.integer(forKey: "TotalCycles")
            return cycles > 0 ? cycles : 1
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TotalCycles")
        }
    }
    
    // MARK: - UI Elements
    private lazy var backButton: IconButton = {
        let button = IconButton(imageName: "Back-Icon", target: self, action: #selector(backButtonPressed))
        return button
    }()
    
    private let settingLabel = UILabel(text: "Setting", font: .boldSystemFont(ofSize: 25), textColor: .white)
    private let colorPickerLabel = UILabel(text: "Choose Color", font: .boldSystemFont(ofSize: 20), textColor: .white)
    private let soundsChooseLabel = UILabel(text: "Choose Sounds", font: .boldSystemFont(ofSize: 20), textColor: .white)
    private let settIntervalLabel = UILabel(text: "Choose Pomodoro Interval", font: .boldSystemFont(ofSize: 20), textColor: .white)
    
    private let cyclesValueLabel: UILabel = {
        let label = UILabel()
        label.text = "\(UserDefaults.standard.integer(forKey: "TotalCycles"))"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cyclesStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.stepValue = 1
        stepper.value = Double(UserDefaults.standard.integer(forKey: "TotalCycles"))
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private var buttonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .customColor
        view.layer.cornerRadius = 20
        view.addShadowOnView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blueButton = ColorButton(color: .customBlue)
    private let greenButton = ColorButton(color: .green)
    private let blackButton = ColorButton(color: .black)
    private let orangeButton = ColorButton(color: .orange)
    private let brownButton = ColorButton(color: .brown)
    
    
    private func buttonAnimate(_ button: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform(scaleX: 1.1 , y: 0.90)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc private func blueButtonTapped() {
        buttonAnimate(blueButton)
        UIColor.updateCustomColor(to: .customBlue)
        print("Color button tapped!")
    }
    
    @objc private func greenButtonTapped() {
        buttonAnimate(greenButton)
        UIColor.updateCustomColor(to: .customGreen)
        print("Color button tapped!")
    }
    
    @objc private func blackButtonTapped() {
        buttonAnimate(blackButton)
        UIColor.updateCustomColor(to: .black)
        print("Color button tapped!")
    }
    @objc private func orangeButtonTapped() {
        buttonAnimate(orangeButton)
        UIColor.updateCustomColor(to: .orange)
        print("Color button tapped!")
    }
    @objc private func brownButtonTapped() {
        buttonAnimate(brownButton)
        UIColor.updateCustomColor(to: .brown)
        print("Color button tapped!")
    }
    
        
    private lazy var stackView = UIStackView(arrangedSubviews: [blueButton,
                                                                greenButton,
                                                                blackButton,
                                                                orangeButton,
                                                                brownButton],
                                             
                                             axis: .horizontal,
                                             spacing: 10)
    
    // MARK: - SoundSelectionDelegate
    func didSelectSound(_ sound: SoundType) {
        sound.play()
        print("Сохраненный звук: \(UserDefaults.standard.string(forKey: "SelectedSound") ?? "nil")")
    }
    
    // MARK: - Actions
    @objc func backButtonPressed() {
        self.backButton.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.backButton.alpha = 1
        })
        totalCycles = Int(cyclesStepper.value)
        delegate?.didUpdateTotalCycles(totalCycles)
        NotificationCenter.default.post(name: Notification.Name("SoundDidChange"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("TotalCyclesDidChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCustomColor), name: .customColorDidChange, object: nil)
        
        self.dismiss(animated: true)
    }
    
    @objc private func cyclesStepperChanged() {
        let cycles = Int(cyclesStepper.value)
        cyclesValueLabel.text = "\(cycles)"
        UserDefaults.standard.set(cycles, forKey: "TotalCycles")
        if UserDefaults.standard.synchronize() {
            totalCycles = cycles
            delegate?.didUpdateTotalCycles(cycles)
        } else {
            print("Ошибка: не удалось сохранить количество циклов в UserDefaults")
        }
    }
    
    let soundSelectionView = SoundSelectionView(selectedSound: .defaultSound)
    
    // MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundSelectionView.delegate = self
        view.backgroundColor = .customColor
        soundSelectionView.addShadowOnView()
        cyclesStepper.addTarget(self, action: #selector(cyclesStepperChanged), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCustomColor), name: .customColorDidChange, object: nil)
        setupUI()
        setConstraints()
    }
    
    @objc private func updateCustomColor() {
        view.backgroundColor = .customColor
        buttonBackgroundView.backgroundColor = .customColor
    }
    
    private func setupUI() {
        view.addSubview(colorPickerLabel)
        view.addSubview(buttonBackgroundView)
        view.addSubview(backButton)
        view.addSubview(settingLabel)
        view.addSubview(stackView)
        view.addSubview(soundsChooseLabel)
        view.addSubview(cyclesValueLabel)
        view.addSubview(cyclesStepper)
        soundSelectionView.translatesAutoresizingMaskIntoConstraints = false
        blueButton.addTarget(self, action: #selector(blueButtonTapped) , for: .touchUpInside)
        greenButton.addTarget(self, action: #selector(greenButtonTapped) , for: .touchUpInside)
        blackButton.addTarget(self, action: #selector(blackButtonTapped) , for: .touchUpInside)
        orangeButton.addTarget(self, action: #selector(orangeButtonTapped) , for: .touchUpInside)
        brownButton.addTarget(self, action: #selector(brownButtonTapped) , for: .touchUpInside)
        view.addSubview(soundSelectionView)
        view.addSubview(settIntervalLabel)
    }
}

extension SettingsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            settingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            
            buttonBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            buttonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonBackgroundView.heightAnchor.constraint(equalToConstant: 150),
            
            colorPickerLabel.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 20),
            colorPickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: buttonBackgroundView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: buttonBackgroundView.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: buttonBackgroundView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            soundsChooseLabel.topAnchor.constraint(equalTo: buttonBackgroundView.bottomAnchor, constant: 20),
            soundsChooseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            soundSelectionView.topAnchor.constraint(equalTo: soundsChooseLabel.topAnchor, constant: 40),
            soundSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            soundSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            soundSelectionView.heightAnchor.constraint(equalToConstant: 200),
            
            settIntervalLabel.topAnchor.constraint(equalTo: soundSelectionView.bottomAnchor, constant: 20),
            settIntervalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cyclesValueLabel.topAnchor.constraint(equalTo: settIntervalLabel.bottomAnchor, constant: 30),
            cyclesValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),
            cyclesValueLabel.trailingAnchor.constraint(equalTo: cyclesStepper.leadingAnchor, constant: -10),
            cyclesValueLabel.widthAnchor.constraint(equalToConstant: 50),
            
            cyclesStepper.centerYAnchor.constraint(equalTo: cyclesValueLabel.centerYAnchor),
            cyclesStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
}

