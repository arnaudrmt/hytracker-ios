//
//  PlayerViewModel.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import Foundation
internal import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    
    @Published var playerUUID: String = ""
    @Published var playerName: String = ""
    @Published var errorMessage: String? = nil
    
    @Published var hypixelPlayer: HypixelAPI.HypixelPlayer? = nil
    
    var hypixelName: String { return hypixelPlayer?.displayName ?? "" }
    var hypixelLevel: Double { return hypixelPlayer?.hypixelLevel ?? 0 }
    
    var bedwarsWins: Int { hypixelPlayer?.stats?.bedwars?.wins ?? 0 }
    var bedwarsKD: Double { hypixelPlayer?.stats?.bedwars?.kdRatio ?? 0 }
    
    var skyWarsWins: Int { hypixelPlayer?.stats?.skywars?.wins ?? 0 }
    var skyWarsKD: Double { hypixelPlayer?.stats?.skywars?.kdRatio ?? 0 }
    
    func findPlayer(name: String) {
        Task {
            if let uuid = await MojangAPI.getUUID(name: name) {
                self.playerUUID = uuid
                self.playerName = name
                self.errorMessage = nil
                findHypixelPlayer(uuid: uuid)
            } else {
                self.errorMessage = "Player not found"
                self.playerUUID = ""
            }
        }
    }
    
    func findHypixelPlayer(uuid: String) {
        Task {
            do {
                if let player = try await HypixelAPI.getPlayer(uuid: uuid) {
                    self.hypixelPlayer = player
                } else {
                    self.errorMessage = "Player never logged on Hypixel"
                }
            } catch {
                self.errorMessage = "Hypixel Error: \(error.localizedDescription)"
            }
        }
    }
    
    func reset() {
        self.playerUUID = ""
        self.playerName = ""
        self.hypixelPlayer = nil
        self.errorMessage = nil
    }
}
