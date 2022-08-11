//
//  WelcomeRouter.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 12.08.2022.
//

import Foundation
import UIKit

enum WelcomeRouterDestination {
    case login, register
}

class WelcomeRouter: Router {
    weak var sourceViewController: UIViewController?
    
    required init(sourceViewController: UIViewController?) {
        self.sourceViewController = sourceViewController
    }
    
    func navigate(to destination: WelcomeRouterDestination) {
        switch destination {
        case .login:
            let vc = LoginViewController()
            sourceViewController?.navigationController?.pushViewController(vc, animated: true)
        case .register:
            let vc = RegisterViewController()
            sourceViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
