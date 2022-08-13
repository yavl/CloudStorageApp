//
//  FirebaseProfile.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation
import FirebaseAuth

class FirebaseProfile: Profile {
    var email: String {
        guard let user = Auth.auth().currentUser else { return "" }
        return user.email ?? ""
    }
}
