//
//  WelcomeViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

protocol WelcomeViewModelProtocol {
    var viewState: Observable<WelcomeViewState> { get set }
    
    func userLoggedIn()
    func userLoggedOut()
    func logout()
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    var viewState = Observable(WelcomeViewState.initial)
    
    func userLoggedIn() {
        viewState.value = .loggedIn
        print("logged in")
    }
    
    func userLoggedOut() {
        viewState.value = .loggedOut

        print("logged out")
    }
    
    func logout() {
        env.authService.logout()
    }
}
