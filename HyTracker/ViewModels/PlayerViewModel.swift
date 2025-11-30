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
    
    @Published var serverPlayerCount: Int = 0
    
    @Published var playerUUID: String = ""
    @Published var playerName: String = ""
    @Published var errorMessage: String? = nil
    
    @Published var guildName: String? = nil
    @Published var guildTag: String? = nil
    
    @Published var hypixelPlayer: HypixelPlayer? = nil
    @Published var skyblockProfiles: [SkyblockProfile] = []
    
    @Published var armor: [SkyblockItem] = []
    @Published var equipment: [SkyblockItem] = []
    
    var hypixelName: String { return hypixelPlayer?.displayName ?? "" }
    var hypixelLevel: Double { return hypixelPlayer?.hypixelLevel ?? 0 }
    
    func fetchServerStatus() {
        Task {
            do {
                let count = try await HypixelAPI.getPlayerCount()
                self.serverPlayerCount = count
            } catch {
                print("Error status: \(error)")
            }
        }
    }
    
    func findPlayer(name: String) async {
        if let uuid = await MojangAPI.getUUID(name: name) {
            self.playerUUID = uuid
            self.playerName = name
            self.errorMessage = nil
            await findHypixelPlayer(uuid: uuid)
        } else {
            self.errorMessage = "Player not found"
            self.playerUUID = ""
        }
    }
    
    func findHypixelPlayer(uuid: String) async {
        Task {
            do {
                if let player = try await HypixelAPI.getPlayer(uuid: uuid) {
                    self.hypixelPlayer = player
                    
                    if let guild = try await HypixelAPI.getGuild(uuid: uuid) {
                        self.guildName = guild.name
                        self.guildTag = guild.tag
                    } else {
                        self.guildName = nil
                    }
                    
                    if let profiles = try? await HypixelAPI.getSkyblockProfiles(uuid: uuid) {
                        self.skyblockProfiles = profiles.sorted { ($0.selected) && !($1.selected) }
                    } else {
                        self.skyblockProfiles = []
                    }
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
        self.guildName = nil
        self.guildTag = nil
        self.skyblockProfiles = []
    }
}
