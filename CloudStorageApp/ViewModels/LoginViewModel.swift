//
//  LoginViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

protocol LoginViewModelProtocol {
    func loginButtonTapped(email: String, password: String, completion: @escaping (Error?) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    private let authService = FirebaseAuthorizationService()
    
    func loginButtonTapped(email: String, password: String, completion: @escaping (Error?) -> Void) {
        authService.login(email: email, password: password) { profile, error in
            defer {
                completion(error)
            }
            if let error = error {
                print("failed to log in: \(error.localizedDescription)")
                return
            }
            guard let profile = profile else {
                return
            }
            // do something with profile
        }
    }
}
