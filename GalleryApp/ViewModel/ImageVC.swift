//
//  ImageVC.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 15/07/23.
//

import UIKit

class ImageVC: UIViewController {
    
    let imageView = UIImageView()
    var imageCache: [Int: UIImage] = [:]
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwipeGesture()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        updateImage() 
    }
    
    deinit {
        imageCache.removeAll()
    }
    
    func addSwipeGesture() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
    }
    
    
    @objc private func handleLeftSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard imageCache.count > 0 else {
            return
        }
        
        index = (index! + 1) % imageCache.count
        updateImage()
    }
    
    @objc private func handleRightSwipe(_ gesture: UISwipeGestureRecognizer) {
        
        if index == 0 {
            return
        }
        
        index = (index! - 1)
        
        updateImage()
    }
    
    private func updateImage() {
        if let index = index {
            imageView.image = imageCache[index]
        }
    }
    
}
