//
//  PlayerViewModel+Games.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation

extension PlayerViewModel {
    
    // --- Bedwars Game Stats ---
    
    var bedwarsGamesPlayed: Int { hypixelPlayer?.stats?.bedwars?.gamesPlayed ?? 0 }
    var bedwarsWins: Int { hypixelPlayer?.stats?.bedwars?.wins ?? 0 }
    var bedwarsLosses: Int { hypixelPlayer?.stats?.bedwars?.losses ?? 0 }
    var bedwarsKills: Int { hypixelPlayer?.stats?.bedwars?.kills ?? 0 }
    var bedwarsDeaths: Int { hypixelPlayer?.stats?.bedwars?.deaths ?? 0 }
    var bedwarsKD: Double { hypixelPlayer?.stats?.bedwars?.kdRatio ?? 0 }
    var bedwarsFinalKills: Int { hypixelPlayer?.stats?.bedwars?.finalKills ?? 0 }
    var bedwarsFinalDeaths: Int { hypixelPlayer?.stats?.bedwars?.finalDeaths ?? 0 }
    
    // --- SkyWars Game Stats ---
    
    var skyWarsGamesPlayed: Int { hypixelPlayer?.stats?.skywars?.gamesPlayed ?? 0 }
    var skyWarsWins: Int { hypixelPlayer?.stats?.skywars?.wins ?? 0 }
    var skyWarsLosses: Int { hypixelPlayer?.stats?.skywars?.losses ?? 0 }
    var skyWarsKills: Int { hypixelPlayer?.stats?.skywars?.kills ?? 0 }
    var skyWarsDeaths: Int { hypixelPlayer?.stats?.skywars?.deaths ?? 0 }
    var skyWarsKD: Double { hypixelPlayer?.stats?.skywars?.kdRatio ?? 0 }
    
    // --- Duels Game Stats ---
    
    var duelsGamesPlayed: Int { hypixelPlayer?.stats?.duels?.gamesPlayed ?? 0 }
    var duelsWins: Int { hypixelPlayer?.stats?.duels?.wins ?? 0 }
    var duelsLosses: Int { hypixelPlayer?.stats?.duels?.losses ?? 0 }
    var duelsKills: Int { hypixelPlayer?.stats?.duels?.kills ?? 0 }
    var duelsDeaths: Int { hypixelPlayer?.stats?.duels?.deaths ?? 0 }
    var duelsKD: Double { hypixelPlayer?.stats?.duels?.kdRatio ?? 0 }
    
    // --- Murder Mystery Game Stats ---
    
    var mmGamesPlayed: Int { hypixelPlayer?.stats?.murderMystery?.gamesPlayed ?? 0 }
    var mmCoins: Int { hypixelPlayer?.stats?.murderMystery?.coins ?? 0 }
    var mmWins: Int { hypixelPlayer?.stats?.murderMystery?.wins ?? 0 }
    var mmLosses: Int { hypixelPlayer?.stats?.murderMystery?.losses ?? 0 }
    var mmKils: Int { hypixelPlayer?.stats?.murderMystery?.kills ?? 0 }
    
}
