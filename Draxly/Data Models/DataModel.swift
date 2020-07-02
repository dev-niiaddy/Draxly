//
//  DataModel.swift
//  Draxly
//
//  Created by Godwin Addy on 6/27/20.
//  Copyright © 2020 Godwin Addy. All rights reserved.
//

import Foundation

class DataModel {
    private let checklistIndexKey = "ChecklistIndex"
    private let firstTimeKey = "FirstTime"
    
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: checklistIndexKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: checklistIndexKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // MARK:- Data Saving
    func documentsDirectory() -> URL {
        let paths  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklist() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath() , options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        if let data = try? Data(contentsOf: dataFilePath()) {
            
            let decoder = PropertyListDecoder()
            
            do {
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch {
                print("Error decoding array \(error.localizedDescription)")
            }
            
        }
    }
    
    func registerDefaults() {
        let dictionary = [ checklistIndexKey: -1, firstTimeKey: true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: firstTimeKey)
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: firstTimeKey)
            userDefaults.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sort(by: { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        })
    }
}
