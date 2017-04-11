//
//  FilterHomeTableViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-03-29.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class FilterHomeTableViewController: UITableViewController {

    let nameLabel = ["All", "Instagram", "Twitter"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }

    @IBAction func cancelButton(_ sender: Any) {
        
        let isPresentingInFilter = presentingViewController is UITabBarController
        
        if isPresentingInFilter {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }

    @IBAction func doneButton(_ sender: Any) {
        
        self.saveSelection()
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
        
        let isPresentingInFilter = presentingViewController is UITabBarController
        
        if isPresentingInFilter {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    func saveSelection() {
        for i in 0..<self.nameLabel.count {
            let indexPath = NSIndexPath(item: i, section: 0)
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            
            let defaults = UserDefaults.standard
            
            if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
                defaults.set(true, forKey: self.nameLabel[i])
            }
            else {
                defaults.set(false, forKey: self.nameLabel[i])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        
        for i in 0..<self.nameLabel.count {
            let otherIndex = NSIndexPath(row: i, section: 0)
            
            // row that has been selected stays checkmarked
            if otherIndex.row == indexPath.row {
                tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else {
                tableView.cellForRow(at: otherIndex as IndexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.nameLabel.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCell", for: indexPath) 
            cell.textLabel?.text = self.nameLabel[indexPath.row]
            
            let defaults = UserDefaults.standard
            
            if defaults.bool(forKey: self.nameLabel[indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            
            cell.tag = indexPath.row
            return cell
            
        }
        else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilterTableViewCell
        
            cell.nameLabel.text? = self.nameLabel[indexPath.row]
        
            let defaults = UserDefaults.standard
        
            if defaults.bool(forKey: self.nameLabel[indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        
            if indexPath.row == 1 {
                cell.logoImage.image = UIImage(named: "Instagram_2016_icon copy")
            }
            else if indexPath.row == 2 {
                cell.logoImage.image = UIImage(named: "twitterIcon")
            }
        
        
            cell.tag = indexPath.row
            return cell
        }
        
    }
}
