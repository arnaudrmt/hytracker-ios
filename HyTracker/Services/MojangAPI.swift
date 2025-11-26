//
//  MojangService.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import Foundation

struct MojangAPI {
    
    private struct MojangPlayer: Decodable {
        let id: String
        let name: String
    }
    
    static func getUUID(name: String) async -> String? {
        
        guard let url = URL(string: "https://api.mojang.com/users/profiles/minecraft/\(name)") else {
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                return nil
            }
            
            let result = try JSONDecoder().decode(MojangPlayer.self, from: data)
            return result.id
            
        } catch {
            print("Error Mojang API: \(error.localizedDescription)")
            return nil
        }
    }
}
