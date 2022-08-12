//
//  RegisterViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

class RegisterViewModel {
    private let authService = FirebaseAuthorizationService()
    
    func registerButtonTapped(email: String, password: String) {
        authService.register(email: email, password: password) { profile, error in
            if let error = error {
                print("failed to create user: \(error.localizedDescription)")
                return
            }
            guard let profile = profile else {
                return
            }
            // do something with profile
        }
    }
}
