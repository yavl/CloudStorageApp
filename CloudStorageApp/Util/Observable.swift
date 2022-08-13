//
//  Observable.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation

/// copy/paste: https://stackoverflow.com/a/71045059
class Observable<T> {
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    
    init( _ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
