//
//  ButtonTableViewCell.swift
//  fos
//
//  Created by Karson Chau on 2017-03-21.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit
import EventKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rrsp: UIButton!
    @IBOutlet weak var addToCalendar: UIButton!
    
    var selectedEvent: Events? = nil
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
        
        
        
        let calendarAlert = UIAlertController(title: "Add To Calendar", message: "Add this event to your calendar as a reminder", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            
            let eventStore : EKEventStore = EKEventStore()
            let date = Date()
            let myLocale = Locale(identifier: "bg_BG")
            
            if let myTimezone = TimeZone(abbreviation: TimeZone.current.abbreviation()!) {
                print("\(myTimezone.identifier)")
            }
            
            let formatter = DateFormatter()
            formatter.locale = myLocale
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            
            let dateStr = formatter.string(from: date)
            print("1. \(dateStr)")
            
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = myLocale
            
            let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
            let monthName = calendar.monthSymbols[dateComponents.month! - 1]
            print ("2. \(dateComponents.day!) \(monthName) \(dateComponents.year!)")
            
            if let componentsBasedDate = calendar.date(from: dateComponents) {
                let componentsBasedDateStr = formatter.string(from: componentsBasedDate)
                print("3. \(componentsBasedDateStr)")
            }
            
            // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
            
            eventStore.requestAccess(to: .event) { (granted, error) in
                
                if (granted) && (error == nil) {
                    print("granted \(granted)")
                    print("error \(String(describing: error))")
                    
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                    
                    event.title = (self.selectedEvent?.name)!
                    event.startDate = Date()
                    event.endDate = Date()
                    event.notes = self.selectedEvent?.description
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    print("Saved Event")
                    let alert = UIAlertController(title: "Event Added", message: "\(event.title) is now in your calendar", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.delegate?.present(alert, animated: true, completion: nil)
                }
                else{
                    
                    print("failed to save event with error : \(String(describing: error)) or access not granted")
                }
            }
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
