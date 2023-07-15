//
//  Constants.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 14/07/23.
//

import Foundation

class Constants {
    
    static let AppName = "Gallery App"
    
    static let Email = "sparsh-gallery-app-email"
    static let Password = "sparsh-gallery-app-password"
    
    static let baseUrl = "https://api.pexels.com/v1/search?query="
    static let accessKey = "BMtkLZzkJMmUFitI7UuLRrEvWocdpCV5YfEGY51tP9VFjWtmrStvsHpM"
    
    static func getUrlString(query: String = "people") -> String? {
        
        let url = baseUrl + query
        return url
        
    }
}
