//
//  SettingScreenViewController.swift
//  Pomadoro
//
//  Created by apple on 11/11/24.
//

import UIKit
import AudioToolbox

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
            return SystemSoundID(4095)
        case .beep:
            return SystemSoundID(1104)
        case .bell:
            return SystemSoundID(1015)
        case .alarm:
            return SystemSoundID(1016)
        case .chime:
            return SystemSoundID(1007)
        case .whistle:
            return SystemSoundID(1020)
        case .vibration:
            return nil
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

protocol SoundSelectionDelegate: AnyObject {
    func didSelectSound(_ sound: SoundType)
}

class SoundSelectionView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SoundSelectionDelegate?
    
    var sounds: [SoundType] = [.defaultSound, .beep, .bell, .alarm, .chime, .whistle, .vibration]
    
    var selectedSound: SoundType = .defaultSound
    
    let soundKey: String = "SelectedSound"
    
    private let tableView = UITableView()
    
    init(selectedSound: SoundType) {
        super.init(frame: .zero)
        self.selectedSound = selectedSound
        setupTableView()
        loadSelectedSound()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SoundCell")
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .purple
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
        cell.accessoryType = (sound == selectedSound) ? .checkmark : .none
        cell.backgroundColor = .purple
        
        return cell
    }
    
    // MARK: - TableView Delegate
    private var selectedIndex: IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = sounds[indexPath.row]
        
        selectedSound = selected
        selectedIndex = IndexPath(row: sounds.firstIndex(of: selected) ?? 0, section: 0)
        tableView.reloadData()
        UserDefaults.standard.set(selectedSound.rawValue, forKey: soundKey)
        delegate?.didSelectSound(selected)
        selected.play()
        
        if let delegate = delegate {
            delegate.didSelectSound(selected)
        }
    }
    
    private func loadSelectedSound() {
        if let soundRawValue = UserDefaults.standard.string(forKey: soundKey),
           let sound = SoundType(rawValue: soundRawValue) {
            selectedSound = sound
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        loadSelectedSound()
    }
}

