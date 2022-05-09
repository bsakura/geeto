//
//  Project.swift
//  Geeto
//
//  Created by Byan Sakura on 29/04/22.
//

import UIKit

class Project: NSObject, Codable {
    var name: String
    var items: [PrItems]
    
    init(name: String, items: [PrItems]) {
        self.name = name
        self.items = items
        super.init()
    }
    
    init(name: String, items: [PrItems], iconName: String) {
        self.name = name
        self.items = items
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        items.filter { !$0.completed }.count
    }
}
