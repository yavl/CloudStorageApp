//
//  RegisterRouter.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation
import UIKit

enum RegisterRouterDestination {
    case back
}

class RegisterRouter: Router {
    weak var sourceViewController: UIViewController?
    
    required init(sourceViewController: UIViewController?) {
        self.sourceViewController = sourceViewController
    }
    
    func navigate(to destination: RegisterRouterDestination) {
        switch destination {
        case .back:
            sourceViewController?.navigationController?.dismiss(animated: true)
        }
    }
}
