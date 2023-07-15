//
//  SearchNewPicturesCell.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 15/07/23.
//

protocol SearchNewPicturesCellDelegate : AnyObject {
    func didSendQueryParameter(param: String)
}

import UIKit

class SearchNewPicturesCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: SearchNewPicturesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        textField.resignFirstResponder()
        delegate?.didSendQueryParameter(param: textField.text ?? "")
        textField.text = ""
    }
}

