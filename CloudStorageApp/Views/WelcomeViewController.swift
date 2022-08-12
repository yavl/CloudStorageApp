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
        let loginTitle = NSLocalizedString("welcome.registerButton", comment: "sign up")
        button.setTitle(loginTitle, for: .normal)
        return button
    }()
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = WelcomeRouter(sourceViewController: self)
        
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            
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
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
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
    }
    
    @objc private func loginTapped() {
        router?.navigate(to: .login)
    }
    
    @objc private func registerTapped() {
        router?.navigate(to: .register)
    }
}

