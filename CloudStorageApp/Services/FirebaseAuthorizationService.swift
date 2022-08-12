//
//  FirebaseAuthorizationService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuthorizationService: AuthorizationService {
    func login(email: String, password: String, completion: @escaping (_ profile: Profile?, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let authResult = authResult else {
                completion(nil, error)
                return
            }
            let profile = Profile(uid: authResult.user.uid, email: authResult.user.email ?? "")
            completion(profile, nil)
        }
    }
    
    func register(email: String, password: String, completion: @escaping (_ profile: Profile?, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let authResult = authResult else {
                completion(nil, error)
                return
            }
            let profile = Profile(uid: authResult.user.uid, email: authResult.user.email ?? "")
            completion(profile, nil)
        }
    }
}
