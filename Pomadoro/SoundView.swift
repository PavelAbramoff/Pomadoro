//
//  SettingScreenViewController.swift
//  Pomadoro
//
//  Created by apple on 11/11/24.
//
import UIKit
import AudioToolbox

// Enum для выбора звуков
enum SoundType: String {
    case defaultSound = "Default"
    case beep = "Beep"
    case bell = "Bell"
    case alarm = "Alarm"
    case chime = "Chime"
    case whistle = "Whistle"
    case vibration = "Vibration"
    
    var soundID: SystemSoundID? {
        switch self {
        case .defaultSound:
            return SystemSoundID(4095)  // Звук по умолчанию
        case .beep:
            return SystemSoundID(1104)  // Пример звука "Beep"
        case .bell:
            return SystemSoundID(1015)  // Пример звука "Bell"
        case .alarm:
            return SystemSoundID(1016)  // Пример звука "Alarm"
        case .chime:
            return SystemSoundID(1007)  // Пример звука "Chime"
        case .whistle:
            return SystemSoundID(1020)  // Пример звука "Whistle"
        case .vibration:
            return nil  // Вибрация не имеет soundID
        }
    }
    
    func play() {
        if let soundID = self.soundID {
            AudioServicesPlaySystemSound(soundID)
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // Вибрация
        }
    }
}

// Делегат для передачи выбора
protocol SoundSelectionDelegate: AnyObject {
    func didSelectSound(_ sound: SoundType)
}

class SoundSelectionView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: SoundSelectionDelegate?
    
    var sounds: [SoundType] = [.defaultSound, .beep, .bell, .alarm, .chime, .whistle, .vibration]
       var selectedSound: SoundType = .defaultSound
    
    private let tableView = UITableView()
    
    // Инициализатор
    init(selectedSound: SoundType) {
        super.init(frame: .zero)
        self.selectedSound = selectedSound
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SoundCell")
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
        let sound = sounds[indexPath.row]
        
        cell.textLabel?.text = sound.rawValue
        cell.accessoryType = sound == selectedSound ? .checkmark : .none
        
        return cell
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = sounds[indexPath.row]
        
        // Обновляем выбранный звук
        selectedSound = selected
        
        // Перезагружаем таблицу для обновления галочки
        tableView.reloadData()
        
        // Оповещаем делегата о выборе
        delegate?.didSelectSound(selected)
        
        // Проигрываем выбранный звук для проверки
        selected.play()
    }
}

