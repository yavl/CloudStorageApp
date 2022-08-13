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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("storage.addButton", comment: "upload file")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    private let viewModel = StorageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = StorageRouterImplementation(sourceViewController: self)
        
        setupViews()
        setupLayout()
        setupViewModel()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
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
                break
            }
        }
    }
    
    @objc private func addTapped() {
        viewModel.addButtonTapped()
    }
    
    @objc private func refresh() {
        viewModel.refresh()
    }
}

// MARK: - UICollectionViewDataSource

extension StorageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StorageViewController: UICollectionViewDelegate {
    
}
