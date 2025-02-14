//
//  HouItWorkController.swift
//  Pomadoro
//
//  Created by apple on 11/10/24.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    // MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let label = UILabel()
    private let topView = UIView()
    private let backButton = UIButton()
    private let stackView = UIStackView()
    
    private let howToPlayRules = [
        "The original technique has six steps. \nDecide on the task to be done.",
        "Set the Pomodoro timer (typically for 25 minutes).",
        "Work on the task. End work when the timer rings and take a short break (typically 5–10 minutes).",
        "Go back to Step 2 and repeat until you complete four pomodori.",
        "After four pomodori are done, take a long break (typically 20 to 30 minutes) instead of a short break. Once the long break is finished, return to step 2."
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customColor
        NotificationCenter.default.addObserver(self, selector: #selector(updateCustomColor), name: .customColorDidChange, object: nil)
        setupLayout()
    }
    
    @objc private func updateCustomColor() {
        view.backgroundColor = .customColor
    }
    
    // MARK: - Private Methods
    private func setupLayout() {
        configureScrollView()
        configureContentView()
        prepareScrollView()
        configureTopView()
        configureBackButton()
        configureLabel()
        configureStackView()
        addContentToScrollView()
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
    }
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func prepareScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - Back Button
    @objc private func backButtonPressed() {
        UIView.animate(withDuration: 0.3) {
            self.backButton.alpha = 0.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.3) {
                self.backButton.alpha = 1
            }
        }
        self.dismiss(animated: true)
    }
    
    private func configureBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "Back-Icon"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    private func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private func configureTopView() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .customColor
        // Optional styling for the top view
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
    }
    
    private func createMessageView(number: Int, text: String) -> UIStackView {
        let messageView = UIStackView()
        messageView.axis = .horizontal
        messageView.spacing = 10
        messageView.alignment = .top
        
        let numberLabel = UILabel()
        numberLabel.text = "\(number)"
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = .purple
        numberLabel.textColor = .white
        numberLabel.layer.masksToBounds = true
        numberLabel.layer.cornerRadius = 45 / 2
        numberLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = UIColor.systemGray6 // Custom color
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        messageView.addArrangedSubview(numberLabel)
        messageView.addArrangedSubview(containerView)
        
        return messageView
    }
    
    private func addContentToScrollView() {
        contentView.addSubview(topView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        topView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
        ])
        
        topView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        for i in 0..<howToPlayRules.count {
            stackView.addArrangedSubview(createMessageView(number: i + 1, text: howToPlayRules[i]))
        }
    }
}
