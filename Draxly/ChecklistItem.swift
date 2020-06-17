//
//  ChecklistItem.swift
//  Draxly
//
//  Created by Godwin Addy on 6/13/20.
//  Copyright © 2020 Godwin Addy. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text: String
    var checked = false
    
    init(text: String) {
        self.text = text
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
