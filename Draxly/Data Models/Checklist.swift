//
//  Checklist.swift
//  Draxly
//
//  Created by Godwin Addy on 6/21/20.
//  Copyright © 2020 Godwin Addy. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    
    var name: String
    var items = [ChecklistItem]()
    
    init(name: String){
        self.name =  name
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0) { cnt, item in
            cnt + (item.checked ? 0 : 1)
        }
    }
}
