//
//  FirebaseStorageService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation
import FirebaseStorage

fileprivate let dummyFileName = ".dummy.txt"

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
            for folder in result.prefixes {
                items.append(StorageItem(name: folder.name, path: folder.fullPath, type: .folder))
            }
            for item in result.items {
                guard item.name != ".dummy.txt" else { continue }
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
    
    func upload(filePath: String, to path: String) {
        guard let url = URL(string: filePath) else { return }
        let filename = filePath.split(separator: "/").last ?? "unknown-filename"
        let storageRef = storage.reference().child("\(path)/\(filename)")
        print("uid: \(env.profile.uid)")
        print("path: \(path)")
        print("filename: \(filename)")
        print("total: \(env.profile.uid)/\(path)/\(filename)")
        let uploadTask = storageRef.putFile(from: url) { metadata, error in
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
    
    func delete(filePath: String) {
        let storageRef = storage.reference().child(filePath)
        storageRef.delete { error in
            if let error = error {
                print("failed to delete file: \(error.localizedDescription)")
                return
            }
            print("successfully deleted file: \(filePath)")
        }
    }
    
    
}
