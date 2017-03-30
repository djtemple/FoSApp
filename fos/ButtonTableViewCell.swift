//
//  ButtonTableViewCell.swift
//  fos
//
//  Created by Karson Chau on 2017-03-21.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rrsp: UIButton!
    @IBOutlet weak var addToCalendar: UIButton!
    
    var url:String? = nil
    
    var delegate:UITableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    @IBAction func rrspButton(_ sender: Any) {
        //UIApplication.shared.openURL(NSURL(string: "http://www.google.com")! as URL)
        
        UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)

    }

    @IBAction func addToCalendar(_ sender: Any) {
        let calendarAlert = UIAlertController(title: "Add To Calendar", message: "Add this event your calendar as a reminder", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            
            
            print("handle adding to calendar here")
        }
        
         calendarAlert.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction) in
            
            print("Cancel logic here. Nothing happens")
        }
        
        calendarAlert.addAction(cancelAction)
       
        delegate?.present(calendarAlert, animated: true, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
