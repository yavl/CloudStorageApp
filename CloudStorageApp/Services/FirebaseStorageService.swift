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
    
    func list() {
        let storageRef = storage.reference().child("\(env.profile.uid)")
        storageRef.listAll { result, error in
            if let error = error {
                print("failed to list files: \(error.localizedDescription)")
                return
            }
            guard let result = result else { return }
            for item in result.items {
                print("\(item.name)")
            }
        }
    }
    
    func createFolder() {
        
    }
    
    func save() {
        let storageRef = storage.reference().child("\(env.profile.uid)/file.bin")
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
