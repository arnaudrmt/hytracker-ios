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
    
    @Published var hypixelPlayer: HypixelAPI.HypixelPlayer? = nil
    @Published var skyblockProfiles: [HypixelAPI.SkyblockProfile] = []
    
    var hypixelName: String { return hypixelPlayer?.displayName ?? "" }
    var hypixelLevel: Double { return hypixelPlayer?.hypixelLevel ?? 0 }
    
    var bedwarsGamesPlayed: Int { hypixelPlayer?.stats?.bedwars?.gamesPlayed ?? 0 }
    var bedwarsWins: Int { hypixelPlayer?.stats?.bedwars?.wins ?? 0 }
    var bedwarsLosses: Int { hypixelPlayer?.stats?.bedwars?.losses ?? 0 }
    var bedwarsKills: Int { hypixelPlayer?.stats?.bedwars?.kills ?? 0 }
    var bedwarsDeaths: Int { hypixelPlayer?.stats?.bedwars?.deaths ?? 0 }
    var bedwarsKD: Double { hypixelPlayer?.stats?.bedwars?.kdRatio ?? 0 }
    var bedwarsFinalKills: Int { hypixelPlayer?.stats?.bedwars?.finalKills ?? 0 }
    var bedwarsFinalDeaths: Int { hypixelPlayer?.stats?.bedwars?.finalDeaths ?? 0 }
    
    var skyWarsGamesPlayed: Int { hypixelPlayer?.stats?.skywars?.gamesPlayed ?? 0 }
    var skyWarsWins: Int { hypixelPlayer?.stats?.skywars?.wins ?? 0 }
    var skyWarsLosses: Int { hypixelPlayer?.stats?.skywars?.losses ?? 0 }
    var skyWarsKills: Int { hypixelPlayer?.stats?.skywars?.kills ?? 0 }
    var skyWarsDeaths: Int { hypixelPlayer?.stats?.skywars?.deaths ?? 0 }
    var skyWarsKD: Double { hypixelPlayer?.stats?.skywars?.kdRatio ?? 0 }
    
    var duelsGamesPlayed: Int { hypixelPlayer?.stats?.duels?.gamesPlayed ?? 0 }
    var duelsWins: Int { hypixelPlayer?.stats?.duels?.wins ?? 0 }
    var duelsLosses: Int { hypixelPlayer?.stats?.duels?.losses ?? 0 }
    var duelsKills: Int { hypixelPlayer?.stats?.duels?.kills ?? 0 }
    var duelsDeaths: Int { hypixelPlayer?.stats?.duels?.deaths ?? 0 }
    var duelsKD: Double { hypixelPlayer?.stats?.duels?.kdRatio ?? 0 }
    
    var mmGamesPlayed: Int { hypixelPlayer?.stats?.murderMystery?.gamesPlayed ?? 0 }
    var mmCoins: Int { hypixelPlayer?.stats?.murderMystery?.coins ?? 0 }
    var mmWins: Int { hypixelPlayer?.stats?.murderMystery?.wins ?? 0 }
    var mmLosses: Int { hypixelPlayer?.stats?.murderMystery?.losses ?? 0 }
    var mmKils: Int { hypixelPlayer?.stats?.murderMystery?.kills ?? 0 }
    
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
