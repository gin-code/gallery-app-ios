//
//  NetworkManager.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 14/07/23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchPhotoData(query: String, completion: @escaping(Any) -> Void) {
        
        guard let url = Constants.getUrlString(query: query) else { return }
        
        UserDefaults.standard.set(Constants.accessKey, forKey: "AuthToken")
        
        NetworkClass.shared.apiRequest(url: url, params: [:], method: "GET", responseObject: PexelModel.self, callBack: Callback(onSuccess: { response in
            completion(response)
        }, onFailure: { failure in
            print(failure)
        }))
        
    }
    
}
