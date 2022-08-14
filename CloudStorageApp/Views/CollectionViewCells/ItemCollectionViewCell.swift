//
//  ItemCollectionViewCell.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 14.08.2022.
//

import Foundation
import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    private let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "doc"))
        return imageView
    }()
    
    private let filenameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        iconView.image = UIImage(systemName: "doc")
    }
    
    private func setupViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(filenameLabel)
    }
    
    private func setupLayout(viewMode: ViewMode) {
        iconView.snp.removeConstraints()
        filenameLabel.snp.removeConstraints()
        
        switch viewMode {
        case .table:
            iconView.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.height.equalTo(iconView.snp.width)
            }
            
            filenameLabel.snp.makeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(10)
                make.right.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
            }
            filenameLabel.textAlignment = .left
        case .grid:
            iconView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(iconView.snp.width)
                make.centerX.equalToSuperview()
            }
            
            filenameLabel.snp.makeConstraints { make in
                make.top.equalTo(iconView.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
            }
            filenameLabel.textAlignment = .center
        }
    }
    
    func configure(with storageItem: StorageItem, viewMode: ViewMode = .table) {
        filenameLabel.text = storageItem.name
        if storageItem.type == .folder {
            iconView.image = UIImage(systemName: "folder")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        }
        setupLayout(viewMode: viewMode)
    }
}
