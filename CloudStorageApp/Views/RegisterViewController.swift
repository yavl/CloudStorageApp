//
//  RegisterViewController.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 12.08.2022.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let emailTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = NSLocalizedString("register.email.placeholder", comment: "enter email here")
        return textField
    }()
    
    private let passwordTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = NSLocalizedString("register.password.placeholder", comment: "enter password here")
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        let loginTitle = NSLocalizedString("register.registerButton", comment: "sign up")
        button.setTitle(loginTitle, for: .normal)
        return button
    }()
    
    private let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(registerButton)
        
        title = NSLocalizedString("register.title", comment: "create new account")
        
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            let height = UIScreen.main.bounds.height / 4
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(height)
        }
    }
    
    @objc private func registerTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.registerButtonTapped(email: email, password: password)
    }
}
