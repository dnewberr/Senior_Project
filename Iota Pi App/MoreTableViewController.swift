//
//  MoreTableViewController.swift
//  Iota Pi App
//
//  Created by Deborah Newberry on 10/27/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import Firebase

class MoreTableViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
}

class MoreTableViewController: UITableViewController {
    //let optionLabelTexts = ["Logout"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MoreTableViewCell
        
        if (cell.optionLabel.text == "Logout") {
            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "Logout", style: .default, handler: {UIAlertAction in
                try! FIRAuth.auth()!.signOut()
                if let storyboard = self.storyboard {
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(vc, animated: false, completion: nil)
                }})
            alertController.addAction(logoutAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currentUserRosterInfoSegue" {
            let destination = segue.destination as! RosterDetailViewController
            destination.currentBrotherId = RosterManager.sharedInstance.currentUserId
        }
    }
}
