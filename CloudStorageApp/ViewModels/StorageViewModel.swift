//
//  StorageViewModel.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

fileprivate let isTableViewModeKey = "isTableViewModeKey"

protocol StorageViewModelProtocol {
    var currentPath: String { get }
    var viewState: Observable<StorageViewState> { get set }
    var viewMode: Observable<ViewMode> { get set }
    var items: Observable<[StorageItem]> { get }
    
    func createFolderButtonTapped(folderName: String, completion: @escaping (_ success: Bool) -> Void)
    func addFileButtonTapped(filePath: String, completion: @escaping (_ success: Bool) -> Void)
    func deleteButtonTapped(filePath: String, type: StorageItem.ItemType, completion: @escaping (_ success: Bool) -> Void)
    func refresh()
}

class StorageViewModel: StorageViewModelProtocol {
    var currentPath = ""
    /// nil to remove filter
    var filtersByExtension: String?
    var viewState = Observable(StorageViewState.initial)
    var viewMode = Observable(ViewMode.grid)
    var items = Observable([StorageItem]())
    
    private let defaults = UserDefaults.standard
    
    init() {
        let key = defaults.bool(forKey: isTableViewModeKey)
        viewMode.value = key ? .table : .grid
    }
    
    func createFolderButtonTapped(folderName: String, completion: @escaping (_ success: Bool) -> Void = { success in }) {
        env.storageService.createFolder(path: folderName, completion: completion)
    }
    
    func addFileButtonTapped(filePath: String, completion: @escaping (_ success: Bool) -> Void = { success in }) {
        env.storageService.upload(filePath: filePath, to: currentPath, completion: completion)
    }
    
    func deleteButtonTapped(filePath: String, type: StorageItem.ItemType, completion: @escaping (_ success: Bool) -> Void = { success in }) {
        switch type {
        case .folder:
            env.storageService.deleteFolder(path: filePath) { success in
                completion(success)
            }
        case .file:
            env.storageService.delete(filePath: filePath) { success in
                completion(success)
            }
        }
    }
    
    func refresh() {
        viewState.value = .fetching
        env.storageService.list(path: currentPath, filterByExtension: filtersByExtension) { items, error in
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
    
    func switchViewMode() {
        if let value = viewMode.value {
            switch value {
            case .table:
                viewMode.value = .grid
                defaults.set(false, forKey: isTableViewModeKey)
            case .grid:
                viewMode.value = .table
                defaults.set(true, forKey: isTableViewModeKey)
            }
        }
    }
}
