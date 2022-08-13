//
//  AuthorizationService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

protocol AuthorizationService {
    func login(email: String, password: String, completion: @escaping (_ profile: Profile?, _ error: Error?) -> Void)
    func register(email: String, password: String, completion: @escaping (_ profile: Profile?, _ error: Error?) -> Void)
    func logout()
}
