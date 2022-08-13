//
//  RegisterViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

protocol RegisterViewModelProtocol {
    func registerButtonTapped(email: String, password: String, completion: @escaping (Error?) -> Void)
}

class RegisterViewModel: RegisterViewModelProtocol {
    func registerButtonTapped(email: String, password: String, completion: @escaping (Error?) -> Void) {
        env.authService.register(email: email, password: password) { profile, error in
            defer {
                completion(error)
            }
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
