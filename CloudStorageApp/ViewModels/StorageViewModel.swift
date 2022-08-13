//
//  StorageViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

protocol StorageViewModelProtocol {
    var currentPath: String { get }
    var viewState: Observable<StorageViewState> { get set }
    var items: Observable<[StorageItem]> { get }
    
    func addButtonTapped()
    func refresh()
}

class StorageViewModel: StorageViewModelProtocol {
    var currentPath = ""
    var viewState = Observable(StorageViewState.initial)
    var items = Observable([StorageItem]())
    
    func addButtonTapped() {
        env.storageService.save()
    }
    
    func refresh() {
        viewState.value = .fetching
        env.storageService.list(path: currentPath) { items, error in
            if let error = error {
                print("failed to list files in path: \(error.localizedDescription)")
                return
            }
            self.items.value = items
        }
    }
}
