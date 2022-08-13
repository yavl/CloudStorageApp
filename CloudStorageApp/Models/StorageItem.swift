//
//  StorageItem.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation

class StorageItem {
    let name: String
    let path: String
    let type: ItemType
    
    enum ItemType {
        case file
        case folder
    }
    
    init(name: String, path: String, type: ItemType = .file) {
        self.name = name
        self.path = path
        self.type = type
    }
}
