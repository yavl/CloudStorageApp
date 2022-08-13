//
//  WelcomeViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

protocol WelcomeViewModelProtocol {
    var isLoggedIn: Observable<WelcomeViewState> { get set }
    
    func userLoggedIn()
    func userLoggedOut()
    func logout()
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    var isLoggedIn = Observable(WelcomeViewState.initial)
    
    func userLoggedIn() {
        isLoggedIn.value = .loggedIn
        print("logged in")
    }
    
    func userLoggedOut() {
        isLoggedIn.value = .loggedOut

        print("logged out")
    }
    
    func logout() {
        env.authService.logout()
    }
}
