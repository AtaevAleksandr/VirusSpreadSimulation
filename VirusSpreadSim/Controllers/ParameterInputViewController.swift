//
//  ParameterInputViewController.swift
//  VirusSpreadSim
//
//  Created by Aleksandr Ataev on 07.05.2023.
//

import UIKit

final class ParameterInputViewController: UIViewController {


    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "Incoming Parameters"
        addSubviews()
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        addObservers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }

    //MARK: - UIElements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your parameters"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var groupSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Group Size"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var groupSizeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "100"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 7
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        setKeyboardSettings(forUITextField: textField)
        return textField
    }()

    private lazy var infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.text = "Infection Factor"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var infectionFactorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "3"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 7
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        setKeyboardSettings(forUITextField: textField)
        return textField
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Timer"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 7
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        setKeyboardSettings(forUITextField: textField)
        return textField
    }()

    private lazy var simButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Start simulation!", for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.configuration?.cornerStyle = .large
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 4
        button.setTitleColor(.white, for: .normal)
        button.configuration?.baseBackgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startSim), for: .touchUpInside)
        return button
    }()


    //MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 100),

            mainLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            groupSizeLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 50),
            groupSizeLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 10),
            groupSizeTextField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            groupSizeTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: 35),

            infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 20),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 10),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 35),

            timerLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            timerLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            timerTextField.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10),
            timerTextField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            timerTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            timerTextField.heightAnchor.constraint(equalToConstant: 35),

            simButton.topAnchor.constraint(equalTo: timerTextField.bottomAnchor, constant: 50),
            simButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            simButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            simButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [mainLabel, groupSizeLabel, groupSizeTextField, infectionFactorLabel,
         infectionFactorTextField, timerLabel, timerTextField, simButton].forEach { contentView.addSubview($0) }
    }

    @objc private func startSim() {
        let viewController = SimulationViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameSize: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: true)
        scrollView.contentSize = CGSize(width: .zero, height: view.bounds.size.height + keyboardFrameSize.height)
    }

    @objc private func keyboardDidHide(notification: Notification) {
        scrollView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
    }
}

//MARK: - Extension
extension ParameterInputViewController: UITextFieldDelegate {
    private func setKeyboardSettings(forUITextField textField: UITextField) {
        textField.delegate = self
        textField.autocorrectionType = .no
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapOnView)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

