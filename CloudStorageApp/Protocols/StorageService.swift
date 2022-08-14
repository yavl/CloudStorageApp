//
//  StorageService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation

protocol StorageService {
    func list(path: String, completion: @escaping ([StorageItem], Error?) -> Void, filterByExtension: String?)
    func createFolder(path: String, completion: @escaping (_ success: Bool) -> Void)
    func upload(filePath: String, to path: String, completion: @escaping (_ success: Bool) -> Void)
    func rename()
    func delete(filePath: String, completion: @escaping (_ success: Bool) -> Void)
    func deleteFolder(path: String, completion: @escaping (_ success: Bool) -> Void)
}
