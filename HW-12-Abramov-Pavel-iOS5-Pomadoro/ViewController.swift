//
//  ViewController.swift
//  HW-12-Abramov-Pavel-iOS5-Pomadoro
//
//  Created by Pavel Абрамов on 27.04.2022.
//
import UIKit

class ViewController: UIViewController {
    
    enum IntervalType {
        case Pomodoro
        case RestBreak
    }
    
    var intervals: [IntervalType] = [.Pomodoro, .RestBreak, .Pomodoro, .RestBreak, .Pomodoro, .RestBreak, .Pomodoro]
    
    var currentInterval = 0
    var timeRemaining = 0
    var timer = Timer()
    
    // Интервалы по умолчанию
    var pomodoroIntervalTime: Int = 1 // 25 минут
    var restBreakIntervalTime: Int = 1  // 5 минут
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var shapeViev: UIImageView!
    
    // Добавляем UIDatePickers
    let pomodoroPicker = UIDatePicker()
    let restPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationCircular()
        resetToBegining()
        setupDatePickers()
        shapeViev.layer.cornerRadius = 30
        
        startPauseButton.layer.cornerRadius = 8
        startPauseButton.layer.shadowColor = UIColor.black.cgColor  // Цвет тени
        startPauseButton.layer.shadowOpacity = 0.6  // Прозрачность тени
        startPauseButton.layer.shadowOffset = CGSize(width: 5, height: 5)  // Смещение тени
        startPauseButton.layer.shadowRadius = 6  // Радиус размытия тени
        startPauseButton.layer.masksToBounds = false
        
        resetButton.layer.cornerRadius = 8
        resetButton.layer.shadowColor = UIColor.black.cgColor  // Цвет тени
        resetButton.layer.shadowOpacity = 0.5  // Прозрачность тени
        resetButton.layer.shadowOffset = CGSize(width: 5, height: 5)  // Смещение тени
        resetButton.layer.shadowRadius = 15  // Радиус размытия тени
        resetButton.layer.masksToBounds = false
        
        shapeViev.layer.shadowColor = UIColor.black.cgColor  // Цвет тени
        shapeViev.layer.shadowOpacity = 0.5  // Прозрачность тени
        shapeViev.layer.shadowOffset = CGSize(width: 5, height: 5)  // Смещение тени
        shapeViev.layer.shadowRadius = 15  // Радиус размытия тени
        shapeViev.layer.masksToBounds = false
    }
    
    func setupDatePickers() {
        // Настройка UIDatePicker для Pomodoro
        pomodoroPicker.datePickerMode = .countDownTimer
        pomodoroPicker.backgroundColor = .lightGray.withAlphaComponent(0.2)
        pomodoroPicker.countDownDuration = TimeInterval(pomodoroIntervalTime)
        pomodoroPicker.translatesAutoresizingMaskIntoConstraints = false
        pomodoroPicker.layer.cornerRadius = 20  // Замените 10 на нужное значение
        pomodoroPicker.layer.masksToBounds = true
        pomodoroPicker.layer.shadowColor = UIColor.blue.cgColor    // Цвет тени
        pomodoroPicker.layer.shadowOpacity = 0.8                    // Прозрачность тени (0.0 - полностью прозрачная, 1.0 - полностью непрозрачная)
        pomodoroPicker.layer.shadowOffset = CGSize(width: 3, height: 3)  // Смещение тени (положительные значения сдвигают тень вправо и вниз)
        pomodoroPicker.layer.shadowRadius = 8
        
        view.addSubview(pomodoroPicker)
        
        // Настройка UIDatePicker для отдыха
        restPicker.datePickerMode = .countDownTimer
        restPicker.backgroundColor = .lightGray.withAlphaComponent(0.2)
        restPicker.countDownDuration = TimeInterval(restBreakIntervalTime)
        restPicker.translatesAutoresizingMaskIntoConstraints = false
        restPicker.layer.cornerRadius = 20  // Замените 10 на нужное значение
        restPicker.layer.masksToBounds = true
        restPicker.layer.shadowColor = UIColor.blue.cgColor    // Цвет тени
        restPicker.layer.shadowOpacity = 0.8                    // Прозрачность тени (0.0 - полностью прозрачная, 1.0 - полностью непрозрачная)
        restPicker.layer.shadowOffset = CGSize(width: 3, height: 3)  // Смещение тени (положительные значения сдвигают тень вправо и вниз)
        restPicker.layer.shadowRadius = 8
        
        view.addSubview(restPicker)
        
        // Устанавливаем ограничения
        NSLayoutConstraint.activate([
            pomodoroPicker.topAnchor.constraint(equalTo: shapeViev.topAnchor, constant: -120),
            pomodoroPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pomodoroPicker.heightAnchor.constraint(equalToConstant: 100),
            pomodoroPicker.widthAnchor.constraint(equalToConstant: 200),
            //pomodoroPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restPicker.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 10),
            restPicker.heightAnchor.constraint(equalToConstant: 100),
            restPicker.widthAnchor.constraint(equalToConstant: 200),
            restPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @IBAction func startPauseButton(_ sender: Any) {
        if timer.isValid {
            startPauseButton.setTitle("Resume", for: .normal)
            resetButton.isEnabled = true
            pauseTimer()
        } else {
            startPauseButton.setTitle("Pause", for: .normal)
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
        intervalLabel.text = "Ready"
        startPauseButton.setTitle("Start", for: .normal)
        resetButton.isEnabled = false
        resetButton.addShadowOnView()
        timeRemaining = Int(pomodoroPicker.countDownDuration)
        updateDisplay()
    }
    
    func startNextInterval() {
        if currentInterval < intervals.count {
            if intervals[currentInterval] == .Pomodoro {
                timeRemaining = Int(pomodoroPicker.countDownDuration)
                intervalLabel.text = "Get to work!"
            } else {
                timeRemaining = Int(restPicker.countDownDuration)
                intervalLabel.text = "Greate job! Have a rest"
            }
            updateDisplay()
            startTimer()
            currentInterval += 1
        } else {
            resetToBegining()
        }
    }
    
    func updateDisplay() {
        let (minutes, seconds) = minutesAndSeconds(from: timeRemaining)
        minutesLabel.text = formatMinuteOrSecond(minutes)
        secondLabel.text = formatMinuteOrSecond(seconds)
    }
    
    func startTimer() {
        
        startAnimation()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerTick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func timerTick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            updateDisplay()
        } else {
            timer.invalidate()
            startNextInterval()
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
        let circularPath = UIBezierPath(arcCenter: center, radius: 112, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
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

        shapeLayer.strokeColor = UIColor.link.cgColor
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
