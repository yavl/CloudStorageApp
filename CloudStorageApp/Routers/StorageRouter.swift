//
//  StorageRouter.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

enum StorageRouterDestination {
    case back
    case path(path: String)
}

protocol StorageRouter: Router {
    func navigate(to destination: StorageRouterDestination)
    func openDocumentPicker(completion: @escaping (URL) -> Void)
    func openImagePicker(completion: @escaping (URL) -> Void)
}

class StorageRouterImplementation: NSObject, StorageRouter {
    weak var sourceViewController: UIViewController?
    
    var didPickDocument: ((URL) -> Void)?
    
    required init(sourceViewController: UIViewController?) {
        self.sourceViewController = sourceViewController
    }
    
    func navigate(to destination: StorageRouterDestination) {
        switch destination {
        case .back:
            sourceViewController?.navigationController?.popViewController(animated: true)
        case .path(path: let path):
            let vc = StorageViewController(path: path)
            sourceViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openDocumentPicker(completion: @escaping (URL) -> Void) {
        let supportedTypes: [UTType] = [.image, .movie, .video, .mp3, .audio, .quickTimeMovie, .mpeg, .mpeg2Video, .mpeg2TransportStream, .mpeg4Movie, .mpeg4Audio, .appleProtectedMPEG4Audio, .appleProtectedMPEG4Video, .avi, .aiff, .wav, .midi, .livePhoto, .tiff, .gif, .icns]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.delegate = self
        sourceViewController?.present(picker, animated: true)
        self.didPickDocument = completion
    }
    
    func openImagePicker(completion: @escaping (URL) -> Void) {
        
    }
}

// MARK: - UIDocumentPickerDelegate

extension StorageRouterImplementation: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        defer {
            didPickDocument = nil
        }
        guard !urls.isEmpty else { return }
        didPickDocument?(urls[0])
    }
}
