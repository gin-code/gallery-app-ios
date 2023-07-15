//
//  ImageFetcher.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 14/07/23.
//


import UIKit

class ImageDownloader {
    
    static let shared = ImageDownloader()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to download image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to image")
                completion(nil)
                return
            }
            
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
        }
        
        task.resume()
    }
}
