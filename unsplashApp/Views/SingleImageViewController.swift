//
//  SingleImageViewController.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 13.06.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
    var photo: Photo?
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
}
