//
//  SettingsVC.swift
//  GalleryApp
//
//  Created by Sparsh Singh on 15/07/23.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SearchNewPicturesCell", bundle: nil), forCellReuseIdentifier: "SearchNewPicturesCell")
        
        tableView.separatorColor = .clear
        tableView.sectionIndexColor = .clear
    }
    

    func sendData(parameter: String) {
        NotificationCenter.default.post(name: NSNotification.Name("StringNotification"), object: nil, userInfo: ["string": parameter])
    }
   

}

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchNewPicturesCell", for: indexPath) as! SearchNewPicturesCell
            cell.delegate = self
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogOutCell", for: indexPath) as! LogOutCell
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 100
        }
        
        return 200
    }
    
}

extension SettingsVC : SearchNewPicturesCellDelegate, LogOutCellDelegate {
    
    func didSendQueryParameter(param: String) {
        if param == "" || param == " " {
            CommonFunctions.showAlert(with: "Please enter a valid input.")
            return
        } else {
            sendData(parameter: param)
            CommonFunctions.showAlert(with: "Search Sent.")
        }
    }
    
    func didPressedLogOut() {
        
        UserDefaults.standard.set(false, forKey: "logged_in")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginVC")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
    
}


