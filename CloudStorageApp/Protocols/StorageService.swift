//
//  StorageService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation

protocol StorageService {
    func list()
    func createFolder()
    func save()
    func rename()
    func delete()
}
