//
//  StorageService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation

protocol StorageService {
    func list(path: String, completion: @escaping ([StorageItem], Error?) -> Void)
    func createFolder(path: String)
    func save()
    func rename()
    func delete()
}
