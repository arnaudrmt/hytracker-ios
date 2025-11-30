//
//  GameStats.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation

struct BedwarsStats: Decodable {
    let wins: Int?
    let kills: Int?
    let deaths: Int?
    let finalKills: Int?
    let finalDeaths: Int?
    let gamesPlayed: Int?
    
    enum CodingKeys: String, CodingKey {
        case wins = "wins_bedwars"
        case kills = "kills_bedwars"
        case deaths = "deaths_bedwars"
        case finalKills = "final_kills_bedwars"
        case finalDeaths = "final_deaths_bedwars"
        case gamesPlayed = "games_played_bedwars"
    }
}

struct SkyWarsStats: Decodable {
    let wins: Int?
    let kills: Int?
    let deaths: Int?
    let gamesPlayed: Int?
    
    enum CodingKeys: String, CodingKey {
        case wins = "wins"
        case kills = "kills"
        case deaths = "deaths"
        case gamesPlayed = "games_played_skywars"
    }
}

struct DuelStats: Decodable {
    let wins: Int?
    let kills: Int?
    let deaths: Int?
    let gamesPlayed: Int?
    
    enum CodingKeys: String, CodingKey {
        case wins = "wins"
        case kills = "kills"
        case deaths = "deaths"
        case gamesPlayed = "games_played_duels"
    }
}

struct MurderMysteryStats: Decodable {
    let wins: Int?
    let coins : Int?
    let kills: Int?
    let gamesPlayed: Int?
    
    enum CodingKeys: String, CodingKey {
        case wins = "wins"
        case coins = "coins"
        case kills = "kills"
        case gamesPlayed = "games"
    }
}
