//
//  HypixelService.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import Foundation
import SwiftUI

class HypixelAPI {
    
    struct CountsResponse: Decodable {
        let playerCount: Int
    }
    
    struct HypixelResponse: Decodable {
        let success: Bool
        let player: HypixelPlayer?
    }
    
    struct GuildResponse: Decodable {
        let guild: Guild?
    }
    
    struct SkyblockResponse: Decodable {
        let success: Bool
        let profiles: [SkyblockProfile]?
    }
    
    static var apiKey: String {
        return Env.hypixelApiKey
    }
    
    static func getPlayerCount() async throws -> Int {
        guard let url = URL(string: "https://api.hypixel.net/counts?key=\(apiKey)") else { return 0 }
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(CountsResponse.self, from: data)
        return result.playerCount
    }
    
    static func getPlayer(uuid: String) async throws -> HypixelPlayer? {
        
        guard let url = URL(string: "https://api.hypixel.net/player?key=\(HypixelAPI.apiKey)&uuid=\(uuid)") else {
            return nil
        }
        
        do {
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                return nil
            }
            
            let result = try JSONDecoder().decode(HypixelResponse.self, from: data)
            return result.player
            
        } catch {
            print("Error Hypixel API: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getGuild(uuid: String) async throws -> Guild? {
        
        guard let url = URL(string: "https://api.hypixel.net/guild?key=\(apiKey)&player=\(uuid)") else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        
        let result = try JSONDecoder().decode(GuildResponse.self, from: data)
        return result.guild
    }
    
    static func getSkyblockProfiles(uuid: String) async throws -> [SkyblockProfile]? {
        
        guard let url = URL(string: "https://api.hypixel.net/v2/skyblock/profiles?key=\(apiKey)&uuid=\(uuid)") else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        
        let result = try JSONDecoder().decode(SkyblockResponse.self, from: data)
        
        return result.profiles
    }
}
