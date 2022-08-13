//
//  LoginRouter.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation
import UIKit

enum LoginRouterDestination {
    case back
}

protocol LoginRouter: Router {
    func navigate(to destination: LoginRouterDestination)
}

class LoginRouterImplementation: LoginRouter {
    weak var sourceViewController: UIViewController?
    
    required init(sourceViewController: UIViewController?) {
        self.sourceViewController = sourceViewController
    }
    
    func navigate(to destination: LoginRouterDestination) {
        switch destination {
        case .back:
            sourceViewController?.navigationController?.popViewController(animated: true)
        }
    }
}
