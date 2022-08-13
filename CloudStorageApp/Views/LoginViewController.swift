//
//  LoginViewController.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 12.08.2022.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    
    var router: LoginRouter?
    
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
        textField.placeholder = NSLocalizedString("login.email.placeholder", comment: "enter email here")
        return textField
    }()
    
    private let passwordTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = NSLocalizedString("login.password.placeholder", comment: "enter password here")
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        let loginTitle = NSLocalizedString("login.loginButton", comment: "log in")
        button.setTitle(loginTitle, for: .normal)
        return button
    }()
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = LoginRouterImplementation(sourceViewController: self)
        
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        
        title = NSLocalizedString("login.title", comment: "log in")
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
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
    
    @objc private func loginTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.loginButtonTapped(email: email, password: password) { error in
            if let error = error {
                print("failed to log in: \(error.localizedDescription)")
                return
            }
            self.router?.navigate(to: .back)
        }
    }
}
