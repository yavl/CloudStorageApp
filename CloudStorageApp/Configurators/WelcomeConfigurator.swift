//
//  WelcomeConfigurator.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 12.08.2022.
//

import Foundation

protocol WelcomeConfigurator {
    func configure(welcomeViewController: WelcomeViewController)
}

class WelcomeConfiguratorImplementation: WelcomeConfigurator {
    func configure(welcomeViewController: WelcomeViewController) {
        let router = WelcomeRouter(sourceViewController: welcomeViewController)
        welcomeViewController.router = router
    }
}
