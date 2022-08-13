//
//  StorageViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

protocol StorageViewModelProtocol {
    var viewState: Observable<StorageViewState> { get set }
    
    func addButtonTapped()
    func refresh()
}

class StorageViewModel: StorageViewModelProtocol {
    var viewState = Observable(StorageViewState.initial)
    
    func addButtonTapped() {
        env.storageService.save()
    }
    
    func refresh() {
        viewState.value = .fetching
        env.storageService.list()
    }
}
