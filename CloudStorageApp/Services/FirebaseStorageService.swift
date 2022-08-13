//
//  FirebaseStorageService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation
import FirebaseStorage

class FirebaseStorageService: StorageService {
    
    private let storage = Storage.storage()
    
    func list(path: String = "", completion: @escaping ([StorageItem], Error?) -> Void) {
        let storageRef = storage.reference().child("\(env.profile.uid)/\(path)")
        storageRef.listAll { result, error in
            if let error = error {
                print("failed to list files: \(error.localizedDescription)")
                completion([], error)
                return
            }
            guard let result = result else { return }
            var items: [StorageItem] = []
            for item in result.items {
                print("\(item.name)")
                items.append(StorageItem(name: item.name, path: item.fullPath))
            }
            completion(items, nil)
        }
    }
    
    /// Forces "folder creation" by creating `.dummy.txt` file at path
    func createFolder(path: String) {
        let storageRef = storage.reference().child("\(env.profile.uid)/\(path)/.dummy.txt")
        let data = "Dummy text file to create folders".data(using: .utf8)
        let uploadTask = storageRef.putData(data!) { metadata, error in
            if let error = error {
                print("failed to upload file: \(error.localizedDescription)")
            }
            guard let metadata = metadata else { return }
            let size = metadata.size
            print("size: \(size)")
        }
    }
    
    func save() {
        let storageRef = storage.reference().child("\(env.profile.uid)/file3.bin")
        let data = "asdij".data(using: .utf8)
        let uploadTask = storageRef.putData(data!) { metadata, error in
            if let error = error {
                print("failed to upload file: \(error.localizedDescription)")
            }
            guard let metadata = metadata else { return }
            let size = metadata.size
            print("size: \(size)")
        }
    }
    
    func rename() {
        
    }
    
    func delete() {
        
    }
    
    
}
