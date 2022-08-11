//
//  ViewController.swift
//  CloudStorageApp
//
//  Created by Vladislav Nikolaev on 11.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "CloudStorageApp - это приложение для хранения и управления файлами в облачном сервисе."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(helloLabel)
    }
    
    private func setupLayout() {
        helloLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}

