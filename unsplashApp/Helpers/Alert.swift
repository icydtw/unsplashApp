//
//  Alert.swift
//  unsplashApp
//
//  Created by Илья Тимченко on 12.06.2023.
//

import UIKit

/// Error alert class
final class Alert {
    
    // MARK: - Properties
    /// Static property
    static var shared = Alert()
    
    // MARK: - Functions
    /// Private init
    private init() {}
    
    /// Function showing alert with an error
    func displayErrorAlert(message: String, closure: (UIAlertController) -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        closure(alert)
    }
    
}
