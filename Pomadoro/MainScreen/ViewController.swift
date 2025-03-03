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
        case work
        case rest
    }
    
    // MARK: - Properties
    var intervals: [IntervalType] = [.work, .rest ]
    var currentInterval = 0
    var timeRemaining = 0
    var timer = Timer()
    var currentColor = UIColor.customColor
    
    var selectedSound: SoundType = .defaultSound
    
    let soundKey: String = "SelectedSound"
    
    var pomodoroIntervalTime: Int = 1
    var restBreakIntervalTime: Int = 1
    
    private var pausedAnimationProgress: CGFloat = 0
    
    private lazy var rulesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Frame"), for: .normal)
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
    
    private let startTimerLabel = UILabel(text: " Set working time", font: .boldSystemFont(ofSize: 25), textColor: .white)
    private let restTimerLabel = UILabel(text: "     Set rest time", font: .boldSystemFont(ofSize: 25), textColor: .white)
    
    let pomodoroPicker = UIDatePicker()
    let restPicker = UIDatePicker()
    
    
    private lazy var stackRestView = UIStackView(arrangedSubviews: [restPicker,
                                                                    restTimerLabel],
                                                 
                                                 axis: .vertical,
                                                 spacing: 0)
    
    private lazy var stackWorkView = UIStackView(arrangedSubviews: [ startTimerLabel, pomodoroPicker,
                                                                   ],
                                                 
                                                 axis: .vertical,
                                                 spacing: 0)
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customColor
        view.setGradientBackground(colorOne: .whiteLight, colorTwo: .customColor)
        shapeViev.backgroundColor = .customColor
        animationCircular()
        resetToBegining()
        setupDatePickers()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSound), name: Notification.Name("SoundDidChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCustomColor), name: .customColorDidChange, object: nil)
        setupViews()
        setConstraints()
        loadSelectedSound()
        loadIntervals()
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }

    func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }

    
    @objc private func updateCustomColor() {
        view.setGradientBackground(colorOne: .whiteLight, colorTwo: .customColor)
        view.backgroundColor = .customColor
        shapeViev.backgroundColor = .customColor
        updateShapeLayerColor()
    }
    
    private func updateShapeLayerColor() {
        guard let shapeLayer = shapeViev.layer.sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer else { return }
        shapeLayer.strokeColor = UIColor.customColor.cgColor
    }
    
    
    
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(stackWorkView)
        view.addSubview(stackRestView)
        view.addSubview(rulesButton)
        view.addSubview(settingsButton)
        configureButtonStyle(startPauseButton)
        configureButtonStyle(resetButton)
        configureShapeViewStyle()
        shapeViev.layer.cornerRadius = 35
    }
    
    @objc func updateSound() {
        loadSelectedSound()
    }
    
    private func loadSelectedSound() {
        if let soundRawValue = UserDefaults.standard.string(forKey: soundKey),
           let sound = SoundType(rawValue: soundRawValue) {
            selectedSound = sound
        }
    }
    
    func playSelectedSound() {
        selectedSound.play()
    }
    
    func playThreeBeepSounds() {
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.3 * Double(i))) {
                self.playSelectedSound()
            }
        }
    }

    private func configureButtonStyle(_ button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
    }
    
    private func configureShapeViewStyle() {
        shapeViev.layer.shadowColor = UIColor.black.cgColor
        shapeViev.layer.shadowOpacity = 0.5
        shapeViev.layer.shadowOffset = CGSize(width: 5, height: 5)
        shapeViev.layer.shadowRadius = 15
        shapeViev.layer.masksToBounds = false
    }
    
    func setupDatePicker(_ picker: UIDatePicker, duration: Int, shadowColor: UIColor = .greyBlue, backgroundColor: UIColor = .systemGray5) {
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
                        backgroundColor: .lightGray.withAlphaComponent(0.3))
        
        setupDatePicker(restPicker, duration: restBreakIntervalTime,
                        shadowColor: .white,
                        backgroundColor: .lightGray.withAlphaComponent(0.2))
    }
    
    @objc func rulesButtonTapped() {
        self.rulesButton.setImage(UIImage(named: "Frame"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.rulesButton.setImage(UIImage(named: "Frame"), for: .normal)
        }
        
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
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func startPauseButton(_ sender: Any) {
        if timer.isValid {
            startPauseButton.setTitle("RESUME", for: .normal)
            resetButton.isEnabled = true
            settingsButton.isEnabled = true
            pauseTimer()
        } else {
            startPauseButton.setTitle("PAUSE", for: .normal)
            resetButton.isEnabled = false
            settingsButton.isEnabled = false
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
        settingsButton.isEnabled = true
    }
    
    func resetToBegining() {
        currentInterval = 0
        settingsButton.isEnabled = true
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
            settingsButton.isEnabled = false
            
            if intervals[currentInterval] == .work {
                timeRemaining = Int(pomodoroPicker.countDownDuration)
                intervalLabel.text = "Get to work!"
            } else {
                timeRemaining = Int(restPicker.countDownDuration)
                intervalLabel.text = "Great job! Have a rest"
            }
            
            updateDisplay()
            startTimer()
            currentInterval += 1
        } else {
            finishAllIntervals()
        }
    }
    
    func finishAllIntervals() {
        timer.invalidate()
        endBackgroundTask()
        playThreeBeepSounds()
        
        intervalLabel.text = "All done! Great job!"
        
        settingsButton.isEnabled = true
        
        resetToBegining()
    }
    
    func updateDisplay() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        minutesLabel.text = String(format: "%02d", minutes)
        secondLabel.text = String(format: "%02d", seconds)
    }
    
    func startTimer() {
        startAnimation()
        registerBackgroundTask()
        timer = Timer.scheduledTimer(timeInterval: 1,target: self,selector: #selector(timerTick),userInfo: nil,repeats: true)
    }
    
    @objc func timerTick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            updateDisplay()
        } else {
            timer.invalidate()
            endBackgroundTask()
            playThreeBeepSounds()
            
            if currentInterval < intervals.count {
                startNextInterval()
            } else {
                intervalLabel.text = "All done! Great jobe!"
                resetToBegining()
            }
        }
    }
    
    func pauseTimer() {
        timer.invalidate()
        pauseAnimation()
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
        
        shapeLayer.shadowColor = UIColor.blue.cgColor
        shapeLayer.shadowOpacity = 0.5
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowRadius = 10
        
        shapeLayer.strokeColor = UIColor.customColor.cgColor
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
    
    func pauseAnimation() {
            guard let shapeLayer = shapeViev.layer.sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer else { return }
            if let presentationLayer = shapeLayer.presentation() {
                pausedAnimationProgress = presentationLayer.strokeEnd
                shapeLayer.removeAnimation(forKey: "strokeAnimation")
            }
        }
    
    
    private func loadIntervals() {
        let savedCycles = UserDefaults.standard.integer(forKey: "TotalCycles")
        intervals = generateIntervals(forCycles: savedCycles)
    }
    
    private func generateIntervals(forCycles cycles: Int) -> [IntervalType] {
        var intervals: [IntervalType] = []
        for _ in 0..<cycles {
            intervals.append(.work)
            intervals.append(.rest)
        }
        return intervals
    }
}

extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackWorkView.topAnchor.constraint(equalTo: shapeViev.topAnchor, constant: -160),
            stackWorkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackWorkView.heightAnchor.constraint(equalToConstant: 150),
            stackWorkView.widthAnchor.constraint(equalToConstant: 200),
            
            stackRestView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 10),
            stackRestView.heightAnchor.constraint(equalToConstant: 150),
            stackRestView.widthAnchor.constraint(equalToConstant: 200),
            stackRestView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            rulesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rulesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rulesButton.widthAnchor.constraint(equalToConstant: 36),
            rulesButton.heightAnchor.constraint(equalToConstant: 36),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 38),
            settingsButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
}

extension ViewController: SettingsViewControllerDelegate {
    func didUpdateTotalCycles(_ totalCycles: Int) {
        intervals = generateIntervals(forCycles: totalCycles)
        currentInterval = 0
        resetToBegining()
    }
}
