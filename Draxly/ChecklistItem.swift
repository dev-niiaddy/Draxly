//
//  ChecklistItem.swift
//  Draxly
//
//  Created by Godwin Addy on 6/13/20.
//  Copyright © 2020 Godwin Addy. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text: String
    var checked = false
    
    init(text: String) {
        self.text = text
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
