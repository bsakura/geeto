//
//  DataModel.swift
//  Geeto
//
//  Created by Byan Sakura on 29/04/22.
//


import Foundation

class DataModel {
    var lists = [Project]()
    
    var indexOfSelectedList: Int {
        get {
            UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    class func getItemID() -> Int {
        let userDefault = UserDefaults.standard
        let itemID = userDefault.integer(forKey: "ItemID")
        userDefault.set(itemID + 1, forKey: "ItemID")
        
        return itemID
        
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding checklist items \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let fileURL = dataFilePath()
        if let data = try? Data(contentsOf: fileURL) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Project].self, from: data)
            } catch {
                print("Failed decoding checklists from saved directory \(error.localizedDescription)")
            }
        }
    }
    
    func registerDefaults() {
        let dict = [
            "ChecklistIndex": -1,
            "FirstRun": true
        ] as [String: Any]
        UserDefaults.standard.register(defaults: dict)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstRun = userDefaults.bool(forKey: "FirstRun")
        if firstRun {
            lists.append(Project(name: "New Checklist", items: [PrItems(text: "New Item")]))
            indexOfSelectedList = 0
            userDefaults.set(false, forKey: "FirstRun")
        }
    }
}
