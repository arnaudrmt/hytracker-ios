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
        case .bedwars: return "icon_bed"
        case .skywars: return "icon_eye"
        case .duels: return "icon_fishing_rod"
        case .murderMystery: return "icon_bow"
        }
    }
    
    var assetName: String {
        switch self {
        case .bedwars: return "icon_bed"
        case .skywars: return "icon_eye"
        case .duels: return "icon_fishing_rod"
        case .murderMystery: return "icon_bow"
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
