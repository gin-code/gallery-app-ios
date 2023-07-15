//
//  GridVC.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 14/07/23.
//

import UIKit

class GridVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedItems = [Bool]()
    
    var imageCache: [Int: UIImage] = [:]
    
    let cellSpacing: CGFloat = 2.5
    let numberOfCellsPerRow: CGFloat = 2
    let cellHeightMultiplier: CGFloat = 2.0
    
    var PhotoData : PexelModel?
    
    @IBOutlet weak var toolBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName:"MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchData()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = cellSpacing
        collectionView.collectionViewLayout = flowLayout
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        toolBarView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveString(_:)), name: NSNotification.Name("StringNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton!) {
        
        var trueIndexes: [Int] = []

        for (index, value) in selectedItems.enumerated() {
            if value == true {
                trueIndexes.append(index)
            }
        }
        
        for index in trueIndexes.reversed() {
            self.PhotoData?.photos?.remove(at: index)
        }
        
        let updatedImageCache = imageCache.filter { !trueIndexes.contains($0.key) }
        var updatedDictionary: [Int: UIImage] = [:]

        var currentIndex = 0
        for (index, element) in updatedImageCache.sorted(by: { $0.key < $1.key }) {
            if index != currentIndex {
                updatedDictionary[currentIndex] = element
            } else {
                updatedDictionary[index] = element
            }
            currentIndex += 1
        }
        
        imageCache = updatedDictionary
        selectedItems = Array(repeating: false, count: imageCache.count)
        
        toolBarView.isHidden = true
        collectionView.reloadData()
        
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.isSelected = !cell.isSelected
                collectionView.allowsMultipleSelection = true
                selectedItems[indexPath.item] = true
                collectionView.reloadData()
                checkIfAllCellsAreUnselected()
            }
        }
    }
    
    
}


extension GridVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageCache.isEmpty {
            return 0
        } else {
            return imageCache.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
   
        cell.isSelected = selectedItems[indexPath.item]
        
        let altText = PhotoData?.photos?[indexPath.item].alt ?? ""
        let photographer = PhotoData?.photos?[indexPath.item].photographer ?? ""
        
        cell.dateLabel.text = "Photograph By : " + photographer.localizedCapitalized
        cell.nameLabel.text = altText
        
        let placeholderImage = UIImage(named: "placeholderImage")

        if let cachedImage = imageCache[indexPath.item] {
            cell.myImage.image = cachedImage
        } else {
            cell.myImage.image = placeholderImage
        }
        
        if cell.isSelected {
            cell.outerView.backgroundColor = .systemRed
        } else {
            cell.outerView.backgroundColor = .clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        
        if !selectedItems.contains(true) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
            vc.imageCache = imageCache
            vc.index = indexPath.item
            self.present(vc, animated: true)
        }
        
        if cell.isSelected {
            selectedItems[indexPath.item] = false
            cell.outerView.backgroundColor = .clear
        } else {
            selectedItems[indexPath.item] = true
            cell.outerView.backgroundColor = .systemRed
        }
        
        checkIfAllCellsAreUnselected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell
        cell?.outerView.backgroundColor = .clear
        
        if cell?.outerView.backgroundColor == .clear && !selectedItems.contains(true) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
            vc.imageCache = imageCache
            vc.index = indexPath.item
            self.present(vc, animated: true)
        }
        
        checkIfAllCellsAreUnselected()
    }
    
    func checkIfAllCellsAreUnselected() {
        if !selectedItems.contains(true) {
            toolBarView.isHidden = true
            collectionView.allowsMultipleSelection = false
        } else {
            toolBarView.isHidden = false
        }
    }
}

extension GridVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - cellSpacing * 4) / numberOfCellsPerRow
        let height = width * cellHeightMultiplier
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
    
    
}

extension GridVC {
    
    private func fetchData(query: String = "nature") {
        NetworkManager.shared.fetchPhotoData(query: query) { response in
            
            if let data = response as? PexelModel {
                
                self.selectedItems.removeAll()
                self.imageCache.removeAll()
                
                DispatchQueue.global().async { [weak self] in
                    self?.PhotoData = data
                    
                    guard let photoURLs = data.photos?.compactMap({ $0.src?.portrait }) else {
                        return
                    }
                    
                    for (index, url) in photoURLs.enumerated() {
                        ImageDownloader.shared.downloadImage(from: url) { [weak self] image in
                            if let image = image {
                                self?.imageCache[index] = image
                                
                                while self?.selectedItems.count ?? 0 <= index {
                                    self?.selectedItems.append(false)
                                }
                                
                                DispatchQueue.main.async {
                                    self?.collectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func receiveString(_ notification: Notification) {
        if let string = notification.userInfo?["string"] as? String {
            fetchData(query: string)
        }
    }
    
}
