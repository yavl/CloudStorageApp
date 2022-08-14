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
    
    func createFolderButtonTapped(folderName: String)
    func addFileButtonTapped(filePath: String)
    func deleteButtonTapped(filePath: String, type: StorageItem.ItemType)
    func refresh()
}

class StorageViewModel: StorageViewModelProtocol {
    var currentPath = ""
    var viewState = Observable(StorageViewState.initial)
    var items = Observable([StorageItem]())
    
    func createFolderButtonTapped(folderName: String) {
        env.storageService.createFolder(path: folderName)
    }
    
    func addFileButtonTapped(filePath: String) {
        env.storageService.upload(filePath: filePath, to: currentPath)
    }
    
    func deleteButtonTapped(filePath: String, type: StorageItem.ItemType) {
        switch type {
        case .folder:
            env.storageService.deleteFolder(path: filePath)
        case .file:
            env.storageService.delete(filePath: filePath)
        }
    }
    
    func refresh() {
        viewState.value = .fetching
        env.storageService.list(path: currentPath) { items, error in
            defer {
                self.viewState.value = .ready
            }
            if let error = error {
                print("failed to list files in path: \(error.localizedDescription)")
                return
            }
            self.items.value = items
        }
    }
}
