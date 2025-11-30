//
//  MinecraftTextParser.swift
//  HyTracker
//
//  Created by Arnaud on 28/11/2025.
//

import Foundation
import SwiftUI

extension Text {
    init(minecraftStr: String) {
        self = MinecraftTextParser.parse(text: minecraftStr)
    }
}

struct MinecraftTextParser {
    
    static func parse(text: String) -> Text {
        
        if !text.contains("§") {
            return Text(text).foregroundStyle(Color("mc_primary"))
        }
        
        var finalView = Text("")
        let parts = text.components(separatedBy: "§")
        
        for (index, part) in parts.enumerated() {
            
            if index == 0 && !part.isEmpty {
                finalView = Text("\(finalView)\(Text(part).foregroundStyle(Color("mc_gray")))")
                continue
            }
            
            if part.isEmpty { continue }
            
            let colorCode = part.prefix(1)
            let content = part.dropFirst()
            
            let color = mapColor(code: String(colorCode))
            
            finalView = Text("\(finalView)\(Text(content).foregroundStyle(color))")
        }
        
        return finalView
    }
    
    static func mapColor(code: String) -> Color {
        switch code.description.lowercased() {
        case "0": return Color("mc_black")
        case "1": return Color("mc_dark_blue")
        case "2": return Color("mc_dark_green")
        case "3": return Color("mc_dark_aqua")
        case "4": return Color("mc_dark_red")
        case "5": return Color("mc_dark_purple")
        case "6": return Color("mc_gold")
        case "7": return Color("mc_gray")
        case "8": return Color("mc_dark_gray")
        case "9": return Color("mc_blue")
        case "a": return Color("mc_green")
        case "b": return Color("mc_aqua")
        case "c": return Color("mc_red")
        case "d": return Color("mc_red")
        case "e": return Color("mc_light_purple")
        default: return Color("mc_primary")
        }
    }
}

