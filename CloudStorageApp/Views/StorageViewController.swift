//
//  StorageViewController.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 13.08.2022.
//

import Foundation
import UIKit

fileprivate let cellIdentifier = "fileCellidentifier"

class StorageViewController: UIViewController {
    
    var router: StorageRouter?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let createFolderButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("storage.createFolderButton", comment: "create folder")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    private let addFileButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("storage.addFileButton", comment: "upload file")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    private let viewModel = StorageViewModel()
    private var items: [StorageItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = StorageRouterImplementation(sourceViewController: self)
        
        setupViews()
        setupLayout()
        setupViewModel()
        
        viewModel.refresh()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(createFolderButton)
        view.addSubview(addFileButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        createFolderButton.addTarget(self, action: #selector(createFolderTapped), for: .touchUpInside)
        addFileButton.addTarget(self, action: #selector(addFileTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        createFolderButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(addFileButton.snp.top).offset(-10)
        }
        
        addFileButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupViewModel() {
        viewModel.viewState.bind { viewState in
            guard let viewState = viewState else { return }
            
            switch viewState {
            case .initial:
                break
            case .fetching:
                break
            case .ready:
                self.collectionView.reloadData()
                self.refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0)
            }
        }
        
        viewModel.items.bind { items in
            self.items = items ?? []
        }
    }
    
    @objc private func createFolderTapped() {
        // should have placed the logic below somewhere else
        guard viewModel.currentPath.isEmpty else {
            print("can't create subdirectory, go to root folder")
            return
        }
        let title = NSLocalizedString("storage.createFolder.title", comment: "create folder")
        let messageTitle = NSLocalizedString("storage.createFolder.message", comment: "name it")
        let alertController = UIAlertController(title: title, message: messageTitle, preferredStyle: .alert)
        let createTitle = NSLocalizedString("app.create", comment: "create folder")
        alertController.addAction(UIAlertAction(title: createTitle, style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text {
                self.viewModel.createFolderButtonTapped(folderName: "\(text)")
            }
        }))
        let cancelTitle = NSLocalizedString("app.cancel", comment: "cancel")
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("storage.createFolder.placeholder", comment: "folder name")
        }
        present(alertController, animated: true)
    }
    
    @objc private func addFileTapped() {
        viewModel.addFileButtonTapped()
    }
    
    @objc private func refresh() {
        viewModel.refresh()
    }
}

// MARK: - UICollectionViewDataSource

extension StorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StorageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        switch item.type {
        case .file:
            break
        case .folder:
            router?.navigate(to: .path(path: items[indexPath.item].path))
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StorageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
}
