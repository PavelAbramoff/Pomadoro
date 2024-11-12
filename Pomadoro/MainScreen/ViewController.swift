//
//  ViewController.swift
//  HW-12-Abramov-Pavel-iOS5-Pomadoro
//
//  Created by Pavel Абрамов on 27.04.2022.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    enum IntervalType {
        case Pomodoro
        case RestBreak
    }
    
    var intervals: [IntervalType] = [.Pomodoro, .RestBreak ]
    
    var currentInterval = 0
    var timeRemaining = 0
    var timer = Timer()
    
    var selectedSound: SoundType = .defaultSound
    
    private func loadSelectedSound() {
            if let soundRawValue = UserDefaults.standard.string(forKey: "SelectedSound"),
               let sound = SoundType(rawValue: soundRawValue) {
                selectedSound = sound
            }
        }
    
    func playSelectedSound() {
           selectedSound.play()
    }
    
    func playThreeBeepSounds() {
        playSelectedSound()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.playSelectedSound()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.playSelectedSound()
        }
    }
    
    var pomodoroIntervalTime: Int = 1 // 25 минут
    var restBreakIntervalTime: Int = 1  // 5 минут
    
    private lazy var rulesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Frame"), for: .normal)
        //button.tintColor = .white
        button.addTarget(self, action: #selector(rulesButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Setting"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var shapeViev: UIImageView!
    
    private let startTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "Set the working time"
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let restTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "Set rest time"
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pomodoroPicker = UIDatePicker()
    let restPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBlue
        shapeViev.backgroundColor = .customBlue
        animationCircular()
        resetToBegining()
        setupDatePickers()
        setupViews()
        setConstraints()
        loadSelectedSound()
        
    }
    
    private func setupViews() {
        
        view.addSubview(startTimerLabel)
        view.addSubview(pomodoroPicker)
        view.addSubview(restTimerLabel)
        view.addSubview(restPicker)
        view.addSubview(rulesButton)
        view.addSubview(settingsButton)
        configureButtonStyle(startPauseButton)
        configureButtonStyle(resetButton)
        configureShapeViewStyle()
        
        shapeViev.layer.cornerRadius = 35
        
    }
    
    private func configureButtonStyle(_ button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        button.layer.shadowOpacity = 0.6 // Прозрачность тени
        button.layer.shadowOffset = CGSize(width: 5, height: 5) // Смещение тени
        button.layer.shadowRadius = 6 // Радиус размытия тени
        button.layer.masksToBounds = false
    }
    
    private func configureShapeViewStyle() {
        shapeViev.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        shapeViev.layer.shadowOpacity = 0.5 // Прозрачность тени
        shapeViev.layer.shadowOffset = CGSize(width: 5, height: 5) // Смещение тени
        shapeViev.layer.shadowRadius = 15 // Радиус размытия тени
        shapeViev.layer.masksToBounds = false
    }
    
    func setupDatePicker(_ picker: UIDatePicker, duration: Int, shadowColor: UIColor = .systemBlue, backgroundColor: UIColor = .systemGray5) {
        picker.datePickerMode = .countDownTimer
        picker.tintColor = .white
        picker.preferredDatePickerStyle = .automatic
        picker.backgroundColor = backgroundColor
        picker.countDownDuration = TimeInterval(duration)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.layer.cornerRadius = 20
        picker.layer.masksToBounds = true
        picker.layer.shadowColor = shadowColor.cgColor
        picker.layer.shadowOpacity = 0.8
        picker.layer.shadowOffset = CGSize(width: 3, height: 3)
        picker.layer.shadowRadius = 8
        
        view.addSubview(picker)
    }
    
    func setupDatePickers() {
        setupDatePicker(pomodoroPicker, duration: pomodoroIntervalTime,
                        shadowColor: .white,
                        backgroundColor: .lightGray.withAlphaComponent(0.2))
        
        setupDatePicker(restPicker, duration: restBreakIntervalTime,
                        shadowColor: .white,
                        backgroundColor: .lightGray.withAlphaComponent(0.2))
    }
    
    @objc func rulesButtonTapped() {
        self.rulesButton.setImage(UIImage(named: "Frame"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.rulesButton.setImage(UIImage(named: "Frame"), for: .normal)
        }
        
        print(rulesButtonTapped)
        let vc = DescriptionViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func settingsButtonTapped() {
        self.settingsButton.setImage(UIImage(named: "Setting"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.settingsButton.setImage(UIImage(named: "Setting"), for: .normal)
        }
        
        print(settingsButtonTapped)
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func startPauseButton(_ sender: Any) {
        if timer.isValid {
            startPauseButton.setTitle("RESUME", for: .normal)
            resetButton.isEnabled = true
            pauseTimer()
        } else {
            startPauseButton.setTitle("PAUSE", for: .normal)
            resetButton.isEnabled = false
            if currentInterval == 0 {
                startNextInterval()
            } else {
                startTimer()
            }
        }
    }
    
    @IBAction func resetButton(_ sender: Any) {
        if timer.isValid {
            timer.invalidate()
        }
        resetToBegining()
    }
    
    func resetToBegining() {
        currentInterval = 0
        intervalLabel.text = "READY"
        intervalLabel.textColor = .white
        intervalLabel.font = .boldSystemFont(ofSize: 25)
        startPauseButton.setTitle("START", for: .normal)
        resetButton.isEnabled = false
        resetButton.addShadowOnView()
        timeRemaining = Int(pomodoroPicker.countDownDuration)
        updateDisplay()
        
        if let shapeLayer = shapeViev.layer.sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer {
                shapeLayer.removeAllAnimations()
            }
    }
    
    func startNextInterval() {
        if currentInterval < intervals.count {
            if intervals[currentInterval] == .Pomodoro {
                timeRemaining = Int(pomodoroPicker.countDownDuration)
                intervalLabel.text = "Get to work!"
            } else {
                timeRemaining = Int(restPicker.countDownDuration)
                intervalLabel.text = "Greate job! Have a rest"
                print("Круг закончился")
            }
            print("Круг закончился 1")
            updateDisplay()
            startTimer()
            currentInterval += 1
            print("Круг закончился")
        } else {
            resetToBegining()
        }
    }
    
    func updateDisplay() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        minutesLabel.text = String(format: "%02d", minutes)
        secondLabel.text = String(format: "%02d", seconds)
    }
    
    func startTimer() {
        startAnimation()
        timer = Timer.scheduledTimer(timeInterval: 1,target: self,selector: #selector(timerTick),userInfo: nil,repeats: true)
    }
    
    @objc func timerTick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            updateDisplay()
        } else {
            timer.invalidate()
            playThreeBeepSounds()
            
            if currentInterval < intervals.count {
                startNextInterval()
                print("Next interval")
            } else {
                intervalLabel.text = "All done! Greate jobe!"
                print("Круг закончился")
                resetToBegining()
            }
        }
    }
    
    func pauseTimer() {
        timer.invalidate()
        intervalLabel.text = "Paused."
    }
    
    func minutesAndSeconds(from seconds: Int) -> (Int, Int) {
        return (seconds / 60, seconds % 60)
    }
    
    func formatMinuteOrSecond(_ number: Int) -> String {
        return String(format: "%02d", number)
    }
    
    // MARK: Animation
    func animationCircular() {
        let center = CGPoint(x: shapeViev.frame.width / 2, y: shapeViev.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: 113, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 62
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        
        shapeLayer.shadowColor = UIColor.blue.cgColor // Цвет тени
        shapeLayer.shadowOpacity = 0.5 // Прозрачность тени
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0) // Смещение тени (по оси X и Y)
        shapeLayer.shadowRadius = 10 // Радиус размытия тени
        
        shapeLayer.strokeColor = UIColor.customBlue.cgColor
        shapeViev.layer.addSublayer(shapeLayer)
    }
    
    func startAnimation() {
        guard let shapeLayer = shapeViev.layer.sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer else { return }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = CFTimeInterval(timeRemaining)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "strokeAnimation")
    }
}

extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pomodoroPicker.topAnchor.constraint(equalTo: shapeViev.topAnchor, constant: -120),
            pomodoroPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pomodoroPicker.heightAnchor.constraint(equalToConstant: 100),
            pomodoroPicker.widthAnchor.constraint(equalToConstant: 220),
    
            restPicker.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 10),
            restPicker.heightAnchor.constraint(equalToConstant: 80),
            restPicker.widthAnchor.constraint(equalToConstant: 200),
            restPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            rulesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rulesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rulesButton.widthAnchor.constraint(equalToConstant: 36),
            rulesButton.heightAnchor.constraint(equalToConstant: 36),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 38),
            settingsButton.heightAnchor.constraint(equalToConstant: 36),
            
            startTimerLabel.bottomAnchor.constraint(equalTo: pomodoroPicker.topAnchor,constant: -15),
            startTimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restTimerLabel.topAnchor.constraint(equalTo: restPicker.bottomAnchor, constant: 15),
            restTimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
