//
//  CommonFunctions.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 15/07/23.
//

import UIKit

class CommonFunctions {
    
    static func showAlert(with message: String) {
        let alertController = UIAlertController(title: Constants.AppName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
}
