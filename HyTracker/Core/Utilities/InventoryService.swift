//
//  InventoryService.swift
//  HyTracker
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation
import SwiftNBT

class InventoryService {
    
    static func decode(base64: String) -> [SkyblockItem] {
        
        guard let compressedData = Data(base64Encoded: base64) else {
            print("Base 64 Error")
            return []
        }
        
        do {
            let rootTag = try NBTParser.parse(compressedData)
            
            guard let itemList = rootTag["i"]?.array else {
                print("No 'i' list found")
                return []
            }
            
            let items = itemList.map {tag -> SkyblockItem in
                
                let mcID = Int(tag["id"]?.short ?? 0)
                let count = Int(tag["Count"]?.byte ?? 0)
                
                if mcID == 0 { return SkyblockItem.empty }
                
                let display = tag["tag"]?["display"]
                
                let name = display?["Name"]?.string ?? "Unknown Item"
                
                var lore: [String] = []
                if let loreList = display?["Lore"]?.array {
                    lore = loreList.compactMap { $0.string }
                }
                
                let sbID = tag["tag"]?["ExtraAttributes"]?["id"]?.string
                
                return SkyblockItem(
                    minecraftID: mcID,
                    count: count,
                    rawName: name,
                    lore: lore,
                    skyblockID: sbID)
            }
            
            return items
        } catch {
            print("Error parsing NBT: \(error)")
            return []
        }
    }
}
