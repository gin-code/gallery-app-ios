//
//  LogOutCell.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 15/07/23.
//

protocol LogOutCellDelegate: AnyObject {
    func didPressedLogOut()
}

import UIKit

class LogOutCell: UITableViewCell {
    
    var delegate : LogOutCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func logOutButtonAction(_ sender: Any) {
        delegate?.didPressedLogOut()
    }
}
