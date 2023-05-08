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
        scrollView.contentSize = CGSize(width: .zero, height: view.frame.height + 100)
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
        textField.keyboardType = .numberPad
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
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 7
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        setKeyboardSettings(forUITextField: textField)
        return textField
    }()

    private lazy var recalculationPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "Period recalculation"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var recalculationPeriodTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.keyboardType = .numberPad
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
        button.addTarget(self, action: #selector(startSimulation), for: .touchUpInside)
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

            mainLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
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

            recalculationPeriodLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            recalculationPeriodLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            recalculationPeriodTextField.topAnchor.constraint(equalTo: recalculationPeriodLabel.bottomAnchor, constant: 10),
            recalculationPeriodTextField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recalculationPeriodTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            recalculationPeriodTextField.heightAnchor.constraint(equalToConstant: 35),

            simButton.topAnchor.constraint(equalTo: recalculationPeriodTextField.bottomAnchor, constant: 50),
            simButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            simButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            simButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [mainLabel, groupSizeLabel, groupSizeTextField, infectionFactorLabel,
         infectionFactorTextField, recalculationPeriodLabel, recalculationPeriodTextField, simButton].forEach { contentView.addSubview($0) }
    }

    @objc private func startSimulation() {
        if let groupSize = Int(groupSizeTextField.text ?? "0"),
           let recalculationPeriod = Double(recalculationPeriodTextField.text ?? "0"),
           let infectionFactor = Int(infectionFactorTextField.text ?? "0"),
           groupSize > 0,
           recalculationPeriod > 0 {
            let simulationVC = SimulationViewController()
            simulationVC.groupSize = groupSize
            simulationVC.infectionFactor = infectionFactor
            simulationVC.recalculationPeriod = recalculationPeriod

            simulationVC.matrix = makeMatrix(groupSize)
            navigationController?.pushViewController(simulationVC, animated: true)
            dismissKeyboard()
        } else if groupSizeTextField.text == "" || recalculationPeriodTextField.text == "" || infectionFactorTextField.text == "" {
            showAlert()
        }

        func makeMatrix(_ number: Int) -> [[Bool]] {
            let rows = sqrt(Double(number))
            let columns = sqrt(Double(number))
            return Array(repeating: Array(repeating: false, count: Int(columns)), count: Int(rows))
        }
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
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.setContentOffset(CGPoint(x: 0, y: 10), animated: true)
    }

    @objc private func keyboardDidHide(notification: Notification) {
        scrollView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    func showAlert() {
        let alertController = UIAlertController(title: "Dear User,",
                                                message: "Please fill in all the text fields with the required information. Thank you!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
        dismissKeyboard()

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

