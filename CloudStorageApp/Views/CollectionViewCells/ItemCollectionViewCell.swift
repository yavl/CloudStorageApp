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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconView)
    }
    
    private func setupLayout() {
        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
