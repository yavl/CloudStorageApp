//
//  LoginViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

class LoginViewModel {
    private let authService = FirebaseAuthorizationService()
    
    func loginButtonTapped(email: String, password: String) {
        authService.login(email: email, password: password) { profile, error in
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
