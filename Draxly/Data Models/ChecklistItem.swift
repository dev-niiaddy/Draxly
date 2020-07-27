//
//  ChecklistItem.swift
//  Draxly
//
//  Created by Godwin Addy on 6/13/20.
//  Copyright © 2020 Godwin Addy. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text: String
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    

    
    init(text: String) {
        self.text = text
        self.itemID = DataModel.nextChecklistItemID()
        
        super.init()
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextChecklistItemID()
        
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification() {
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request) for \(itemID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["\(itemID)"])
        
    }
}
