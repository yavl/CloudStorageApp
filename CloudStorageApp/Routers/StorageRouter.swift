//
//  StorageRouter.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation
import UIKit

enum StorageRouterDestination {
    case back
}

protocol StorageRouter: Router {
    func navigate(to destination: StorageRouterDestination)
}

class StorageRouterImplementation: StorageRouter {
    weak var sourceViewController: UIViewController?
    
    required init(sourceViewController: UIViewController?) {
        self.sourceViewController = sourceViewController
    }
    
    func navigate(to destination: StorageRouterDestination) {
        switch destination {
        case .back:
            sourceViewController?.navigationController?.popViewController(animated: true)
        }
    }
}
