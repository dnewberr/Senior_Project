//
//  RosterViewController.swift
//  Iota Pi App
//
//  Created by Deborah Newberry on 11/17/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import UIKit
import SCLAlertView

class RosterTableViewCell: UITableViewCell {
    var brotherId: String!
}

class RosterTableViewController: UITableViewController {
    @IBOutlet weak var clearFilterButton: UIBarButtonItem!
    var brothersArray: [User] = Array(RosterManager.sharedInstance.brothersMap.values)
    var chosenBrotherId: String!
    var filter = ""
    
    @IBAction func searchByName(_ sender: AnyObject) {
        let searchByNameAlert = SCLAlertView()
        let searchField = searchByNameAlert.addTextField()
        searchField.autocapitalizationType = .none
        searchField.autocorrectionType = .no
        searchField.placeholder = "Name"
        
        searchByNameAlert.addButton("Search") {
            if let search = searchField.text {
                self.filter = search
                self.filterRoster()
            }
        }
        
        searchByNameAlert.showTitle(
                "Search Roster",
                subTitle: "Search by first name, last name, and nick name.",
                duration: 0.0,
                completeText: "Cancel",
                style: .info,
                colorStyle: Style.mainColorHex,
                colorTextButton: 0xFFFFFF)
    }
    
    @IBAction func clearFilter(_ sender: AnyObject) {
        self.filter = ""
        self.filterRoster()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.clearFilterButton.isEnabled = false
        self.clearFilterButton.tintColor = UIColor.clear
        self.refreshControl?.addTarget(self, action: #selector(ValidateUsersTableViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.filterRoster()
    }
    
    func refresh() {
        self.filterRoster()
        
        if (self.refreshControl?.isRefreshing)! {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func filterRoster() {
        if !self.filter.trim().isEmpty {
            self.brothersArray = self.brothersArray.filter({
                $0.firstname.lowercased().contains(filter.lowercased())
                    || $0.lastname.lowercased().contains(filter.lowercased())
                    || $0.nickname.lowercased().contains(filter.lowercased())
            })
            self.clearFilterButton.isEnabled = true
            self.clearFilterButton.tintColor = nil
        } else {
            self.brothersArray = Array(RosterManager.sharedInstance.brothersMap.values)
            self.clearFilterButton.isEnabled = false
            self.clearFilterButton.tintColor = UIColor.clear
        }
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !self.brothersArray.isEmpty {
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.backgroundView = Utilities.createNoDataLabel(message: "No brothers found.", width: tableView.bounds.size.width, height: tableView.bounds.size.height)
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brothersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rosterCell", for: indexPath) as! RosterTableViewCell
        
        let currentBrother = brothersArray[indexPath.row]
        
        cell.brotherId = currentBrother.userId
        cell.textLabel!.text = currentBrother.getFullName()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RosterTableViewCell {
            chosenBrotherId = cell.brotherId
            performSegue(withIdentifier: "rosterDetailSegue", sender: self)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rosterDetailSegue" {
            let destination = segue.destination as! RosterDetailViewController
            destination.currentBrotherId = chosenBrotherId
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
