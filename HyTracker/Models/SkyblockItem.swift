//
//  SkyblockItem.swift
//  HyTracker
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation

struct SkyblockItem: Identifiable, Hashable {
    let id = UUID()
    let minecraftID: Int
    let count: Int
    
    let rawName: String
    let lore: [String]
    let skyblockID: String?
    
    var cleanName: String {
        return rawName.replacingOccurrences(of: "§[0-9a-fk-or]", with: "", options: .regularExpression)
    }
    
    var isEmpty: Bool {
        return minecraftID == 0
    }
    
    var iconName: String {
        
        if let sbID = skyblockID {
            return sbID.lowercased()
        }
        
        return "missing_texture"
    }
    
    static let empty = SkyblockItem(minecraftID: 0, count: 0, rawName: "", lore: [], skyblockID: nil)
}
