//
//  ListVC.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 15/07/23.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBarView: UIView!
    
    var selectedItems = [Bool]()
    var PhotoData : PexelModel?
    var imageCache: [Int: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        toolBarView.isHidden = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        
        fetchData(query: "office")
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveString(_:)), name: NSNotification.Name("StringNotification"), object: nil)
    }
    
    
    @IBAction func deleteRowButton(_ sender: Any) {
        
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
        tableView.reloadData()
        
    }
    
    @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                selectedItems[indexPath.row] = true
            }
            tableView.reloadData()
            checkIfAllCellsAreUnselected()
        }
    }
}

extension ListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageCache.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewTableCell", for: indexPath) as! ListViewTableCell
        
        cell.isSelected = selectedItems[indexPath.row]
        
        let altText = PhotoData?.photos?[indexPath.item].alt ?? ""
        let photographer = PhotoData?.photos?[indexPath.item].photographer ?? ""
        
        cell.photographerLabel.text = "Photograph By : " + photographer.localizedCapitalized
        cell.descriptionLabel.text = altText
        
        let placeholderImage = UIImage(named: "placeholderImage")

        if let cachedImage = imageCache[indexPath.item] {
            cell.myImage.image = cachedImage
        } else {
            cell.myImage.image = placeholderImage
        }
        
        if cell.isSelected {
            cell.outerView.backgroundColor = .red
        } else {
            cell.outerView.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ListViewTableCell
        
        if  !selectedItems.contains(true) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
            vc.imageCache = imageCache
            vc.index = indexPath.item
            self.present(vc, animated: true)
        }
        
        if cell.isSelected {
            selectedItems[indexPath.row] = false
            cell.outerView.backgroundColor = .clear
        } else {
            selectedItems[indexPath.row] = true
            cell.outerView.backgroundColor = .systemRed
        }
        
        checkIfAllCellsAreUnselected()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ListViewTableCell
        
        cell.outerView.backgroundColor = .clear
        
        if cell.outerView.backgroundColor == .clear && !selectedItems.contains(true) {
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
        } else {
            toolBarView.isHidden = false
        }
    }
}

extension ListVC {
    
    private func fetchData(query: String = "office") {
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
                                    self?.tableView.reloadData()
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
