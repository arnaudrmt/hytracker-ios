//
//  RecentPlayer.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import Foundation
import SwiftData

@Model
class RecentPlayer: Identifiable {
 
    var id: UUID
    var playerUUID: String
    var playerName: String
    var viewedAt: Date
    
    init(playerUUID: String, playerName: String, viewedAt: Date) {
        self.id = UUID()
        self.playerUUID = playerUUID
        self.playerName = playerName
        self.viewedAt = viewedAt
    }
}
