//
//  FirebaseStorageService.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation
import FirebaseStorage

fileprivate let dummyFileName = ".dummy.txt"
fileprivate let maxFileSizeInMegabytes: Double = 20 // hardcode alert

class FirebaseStorageService: StorageService {
    
    private let storage = Storage.storage()
    
    func list(path: String = "", completion: @escaping ([StorageItem], Error?) -> Void, filterByExtension: String? = nil) {
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
                if let filterByExtension = filterByExtension?.lowercased() {
                    if let fileExtension = item.name.split(separator: ".").last?.lowercased() {
                        guard filterByExtension.contains(fileExtension) else { continue }
                    }
                }
                items.append(StorageItem(name: item.name, path: item.fullPath))
            }
            completion(items, nil)
        }
    }
    
    /// Forces "folder creation" by creating `.dummy.txt` file at path
    func createFolder(path: String, completion: @escaping (_ success: Bool) -> Void = { success in }) {
        // there is no concept of folders in Firebase Storage
        // so, as a workaround, we'll create a dummy text file
        let storageRef = storage.reference().child("\(env.profile.uid)/\(path)/.dummy.txt")
        let data = "Dummy text file to create folders".data(using: .utf8)
        let uploadTask = storageRef.putData(data!) { metadata, error in
            if let error = error {
                print("failed to upload file: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let metadata = metadata else { return }
            let size = metadata.size
            print("size: \(size)")
            completion(true)
        }
    }
    
    func upload(filePath: String, to path: String, completion: @escaping (_ success: Bool) -> Void = { success in }) {
        guard let url = URL(string: filePath) else { return }
        let filename = filePath.split(separator: "/").last ?? "unknown-filename"
        if let fileExtension = filename.split(separator: ".").last {
            switch fileExtension {
            case "livePhoto":
                print(".livePhoto is not allowed to be uploaded")
                return
            case "txt":
                print(".txt is not allowed to be uploaded")
                return
            default:
                break
            }
        }
        let storageRef = storage.reference().child("\(env.profile.uid)/\(path)/\(filename)")
        print("uid: \(env.profile.uid)")
        print("path: \(path)")
        print("filename: \(filename)")
        print("total: \(env.profile.uid)/\(path)/\(filename)")
        let size = sizeInMB(url: url)
        guard size <= maxFileSizeInMegabytes else {
            print("too big size: \(size)MB")
            return
        }
        print("size to upload: \(size) MB")
        let uploadTask = storageRef.putFile(from: url) { metadata, error in
            if let error = error {
                print("failed to upload file: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let metadata = metadata else { return }
            completion(true)
        }
    }
    
    func rename() {
        // it turns out that Firebase Storage itself doesn't have a built-in option for file renaming
        // so the method body is empty
        // however this protocol method could be implemented for other StorageService implementations
    }
    
    func delete(filePath: String, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let storageRef = storage.reference().child(filePath)
        storageRef.delete { error in
            if let error = error {
                print("failed to delete file: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            print("successfully deleted file: \(filePath)")
        }
    }
    
    func deleteFolder(path: String, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        let storageRef = storage.reference().child(path)
        storageRef.listAll { result, error in
            if let error = error {
                print("failed to list in delete folder: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let result = result else { return }
            for item in result.items {
                item.delete { error in
                    if let error = error {
                        print("deleteFolder - failed to remove \(error.localizedDescription)")
                    }
                    print("removed \(item.name)")
                }
            }
            completion(true)
        }
    }
    
    // copy/paste: https://stackoverflow.com/a/47186882
    private func sizeInMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
}
