//
//  GameType.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

enum GameType: String, Identifiable {
    case bedwars, skywars, duels, murderMystery
    
    var id: String {self.rawValue}
    
    var title: String {
        switch self {
        case .bedwars: return "BedWars"
        case .skywars: return "SkyWars"
        case .duels: return "Duels"
        case .murderMystery: return "Murder Mystery"
        }
    }
    
    var icon: String {
        switch self {
        case .bedwars: return "minecraft_block_bed"
        case .skywars: return "minecraft_item_eye_of_ender"
        case .duels: return "minecraft_item_fishing_rod"
        case .murderMystery: return "minecraft_item_bow"
        }
    }
    
    var color: Color {
        switch self {
        case .bedwars: return .red
        case .skywars: return .blue
        case .duels: return .orange
        case .murderMystery: return .purple
        }
    }
}
