//
//  PlayerViewModel+Skyblock.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation

extension PlayerViewModel {
    
    func loadInventoryData(armorBase64: String?, equipmentBase64: String?) {
        
        if let armorString = armorBase64 {
            self.armor = InventoryService.decode(base64: armorString).reversed()
        } else {
            self.armor = []
        }
        
        if let equipString = equipmentBase64 {
            self.equipment = InventoryService.decode(base64: equipString)
        } else {
            self.equipment = []
        }
    }
}
