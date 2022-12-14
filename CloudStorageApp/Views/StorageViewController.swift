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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("storage.filterButton", comment: "filter by extension")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    private let viewModeButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("storage.viewModeButton", comment: "grid or table mode")
        button.setTitle(title, for: .normal)
        return button
    }()
    
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
    var didPickImage: ((URL) -> Void)?
    
    init(path: String = "") {
        viewModel.currentPath = path
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(createFolderButton)
        stackView.addArrangedSubview(addFileButton)
        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(viewModeButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        viewModeButton.addTarget(self, action: #selector(viewModeTapped), for: .touchUpInside)
        createFolderButton.addTarget(self, action: #selector(createFolderTapped), for: .touchUpInside)
        addFileButton.addTarget(self, action: #selector(addFileTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
    }
    
    private func setupViewModel() {
        viewModel.viewState.bind { [unowned self] viewState in
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
        
        viewModel.items.bind { [unowned self] items in
            self.items = items ?? []
        }
        
        viewModel.viewMode.bind { [unowned self] viewMode in
            self.collectionView.reloadData()
        }
    }
    
    @objc private func createFolderTapped() {
        // should have placed the logic below somewhere else
        guard viewModel.currentPath.isEmpty else {
            print("can't create subdirectory, go to root folder")
            let errorMessage = NSLocalizedString("storage.createFolder.alert", comment: "error")
            let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let title = NSLocalizedString("storage.createFolder.title", comment: "create folder")
        let messageTitle = NSLocalizedString("storage.createFolder.message", comment: "name it")
        let alertController = UIAlertController(title: title, message: messageTitle, preferredStyle: .alert)
        let createTitle = NSLocalizedString("app.create", comment: "create folder")
        alertController.addAction(UIAlertAction(title: createTitle, style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text {
                self.viewModel.createFolderButtonTapped(folderName: "\(text)") { success in
                    guard success else { return }
                    self.viewModel.refresh()
                }
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
        let picker = UIImagePickerController()
        picker.delegate = self
        didPickImage = { [unowned self] url in
            self.viewModel.addFileButtonTapped(filePath: url.absoluteString) { success in
                guard success else { return }
                self.viewModel.refresh()
            }
        }
        present(picker, animated: true)
        
//        router?.openDocumentPicker { url in
//            self.viewModel.addFileButtonTapped(filePath: url.absoluteString)
//        }
        
//        router?.openImagePicker { url in
//            self.viewModel.addFileButtonTapped(filePath: url.absoluteString)
//        }
    }
    
    @objc private func refresh() {
        viewModel.refresh()
    }
    
    @objc private func viewModeTapped() {
        viewModel.switchViewMode()
    }
    
    @objc private func filterTapped() {
        // should have placed the logic below somewhere else
        let title = NSLocalizedString("storage.filter.title", comment: "title")
        let messageTitle = NSLocalizedString("storage.filter.message", comment: "message")
        let alertController = UIAlertController(title: title, message: messageTitle, preferredStyle: .alert)
        let okTitle = NSLocalizedString("app.set", comment: "set")
        alertController.addAction(UIAlertAction(title: okTitle, style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text, !text.isEmpty {
                self.viewModel.filtersByExtension = text
                self.viewModel.refresh()
            } else {
                self.viewModel.filtersByExtension = nil
                self.viewModel.refresh()
            }
        }))
        let cancelTitle = NSLocalizedString("app.cancel", comment: "cancel")
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("storage.filter.placeholder", comment: "extension")
        }
        present(alertController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension StorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
        cell.configure(with: items[indexPath.item], viewMode: viewModel.viewMode.value ?? .table)
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
            router?.navigate(to: .path(path: items[indexPath.item].name))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let renameTitle = NSLocalizedString("storage.rename", comment: "rename")
            let rename = UIAction(title: renameTitle, image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                let alert = UIAlertController(title: "Alert", message: "???????????? ?????????????????????????? ?? Firebase Storage, ???????????? ?????????????? ???????????? ????????????/?????????????? ??????????????.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            let deleteTitle = NSLocalizedString("storage.delete", comment: "delete")
            let delete = UIAction(title: deleteTitle, image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { _ in
                let item = self.items[indexPath.item]
                self.viewModel.deleteButtonTapped(filePath: item.path, type: item.type) { success in
                    guard success else { return }
                    DispatchQueue.main.async {
                        self.items.remove(at: indexPath.item)
                        collectionView.deleteItems(at: [indexPath])
                    }
                }
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [rename, delete])
            
        }
        return context
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StorageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        switch viewModel.viewMode.value {
        case .table:
            size = CGSize(width: UIScreen.main.bounds.width, height: 60)
        case .grid:
            size = CGSize(width: 100, height: 60)
        default:
            size = CGSize(width: UIScreen.main.bounds.width, height: 60)
        }
        return size
    }
}

// MARK: - UIImagePickerDelegate

extension StorageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            didPickImage = nil
            picker.dismiss(animated: true)
        }
        if let imageUrl = info[.imageURL] as? URL {
            didPickImage?(imageUrl)
            return
        }
        if let videoUrl = info[.mediaURL] as? URL {
            didPickImage?(videoUrl)
            return
        }
    }
}
