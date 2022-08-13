//
//  WelcomeViewController.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 11.08.2022.
//

import UIKit
import SnapKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    var router: WelcomeRouter?
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = NSLocalizedString("welcome.message", comment: "this is an app")
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        let loginTitle = NSLocalizedString("welcome.loginButton", comment: "log in")
        button.setTitle(loginTitle, for: .normal)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        let registerTitle = NSLocalizedString("welcome.registerButton", comment: "sign up")
        button.setTitle(registerTitle, for: .normal)
        return button
    }()
    
    private let storageButton: UIButton = {
        let button = UIButton(type: .system)
        let storageTitle = NSLocalizedString("welcome.storageButton", comment: "browse files")
        button.setTitle(storageTitle, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let viewModel = WelcomeViewModel()
    private var handle: AuthStateDidChangeListenerHandle?
    
    private enum LoginButtonState {
        case login
        case logout
    }
    
    private var loginButtonState: LoginButtonState = .login {
        didSet {
            var buttonTitle: String
            switch loginButtonState {
            case .login:
                buttonTitle = NSLocalizedString("welcome.loginButton", comment: "log in")
            case .logout:
                buttonTitle = NSLocalizedString("welcome.logoutButton", comment: "log out")
            }
            loginButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = WelcomeRouterImplementation(sourceViewController: self)
        
        setupViews()
        setupLayout()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            guard user != nil else {
                self.viewModel.userLoggedOut()
                return
            }
            self.viewModel.userLoggedIn()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(helloLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(storageButton)
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        storageButton.addTarget(self, action: #selector(storageTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        helloLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.center.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(loginButton)
        }
        
        storageButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(loginButton)
        }
    }
    
    private func setupViewModel() {
        viewModel.viewState.bind { viewState in
            guard let viewState = viewState else { return }
            
            self.registerButton.isHidden = false
            self.storageButton.isHidden = true
            switch viewState {
            case .initial:
                self.loginButtonState = .login
            case .loggedIn:
                self.loginButtonState = .logout
                self.registerButton.isHidden = true
                self.storageButton.isHidden = false
            case .loggedOut:
                self.loginButtonState = .login
            }
        }
    }
    
    @objc private func loginTapped() {
        switch loginButtonState {
        case .login:
            router?.navigate(to: .login)
        case .logout:
            viewModel.logout()
        }
    }
    
    @objc private func registerTapped() {
        router?.navigate(to: .register)
    }
    
    @objc private func storageTapped() {
        router?.navigate(to: .storage)
    }
}

