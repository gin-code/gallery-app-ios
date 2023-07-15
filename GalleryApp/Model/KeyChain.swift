//
//  KeyChain.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 14/07/23.
//

import Foundation
import KeychainSwift

class KeyChain {
    
    static let shared = KeyChain()
    
    private let keychain = KeychainSwift()
    
    func updateEmail(_ email: String) {
        keychain.set(email, forKey: Constants.Email)
    }
    
    func updatePassword(_ password: String) {
        keychain.set(password, forKey: Constants.Password)
    }
    
    func getEmail() -> String? {
        return keychain.get(Constants.Email)
    }
    
    func getPassword() -> String? {
        return keychain.get(Constants.Password)
    }
    
    func resetKeyChain() {
        keychain.delete(Constants.Email)
        keychain.delete(Constants.Password)
    }
    
}
