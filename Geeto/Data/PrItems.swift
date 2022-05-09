//
//  PrItems.swift
//  Geeto
//
//  Created by Byan Sakura on 29/04/22.
//
import Foundation
import UserNotifications

class PrItems: Codable {
    
    init(text: String, completed: Bool = false) {
        self.text = text
        self.completed = completed
        
        itemID = DataModel.getItemID()
        
    }
    
    deinit {
        deleteReminder()
    }
    
    var text: String = ""
    var completed: Bool = false
    var requireReminder: Bool = false
    var dueDate = Date()
    var itemID: Int
    
    func setReminder() {
        print("\n--->setReminder()---")
        if (requireReminder && dueDate > Date()) {
            deleteReminder()
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder: "
            content.body = text
            content.sound = .default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "\(itemID)",
                content: content,
                trigger: trigger)
            
            center.add(request)
            print("set reminder for \(dueDate)")
        }
        print("--->setReminder()--->>>")
    }
    
    func deleteReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    
}
