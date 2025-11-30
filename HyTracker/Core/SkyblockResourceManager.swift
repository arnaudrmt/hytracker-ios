//
//  SkyblockRessourceManager.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation
internal import Combine

class SkyblockResourceManager: ObservableObject {
    
    static let shared = SkyblockResourceManager()
    
    @Published var collectionDefinitions: [String: CollectionItem] = [:]
    @Published var skillDefinitions: [String: SkillDefinition] = [:]
    
    @Published var categories: [String: CollectionCategory] = [:]
    
    let categoryOrder = ["FARMING", "MINING", "COMBAT", "FORAGING", "FISHING", "RIFT", "BOSS", "MISC"]
    
    private init() { }
    
    func loadRessources() async {
        await fetchCollections()
        await fetchSkills()
    }
    
    private func fetchCollections() async {
        guard let url = URL(string: "https://api.hypixel.net/v2/resources/skyblock/collections") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(CollectionsReponse.self, from: data)
            
            await MainActor.run {
                
                self.categories = response.collections
                
                var flatDict: [String: CollectionItem] = [:]
                for (_, category) in response.collections {
                    for (itemID, itemData) in category.items {
                        flatDict[itemID] = itemData
                    }
                }
                self.collectionDefinitions = flatDict
                print("\(flatDict.count) Collections loaded !")
            }
        } catch {
            print("Error loading Collections: \(error)")
        }
    }
    
    private func fetchSkills() async {
        guard let url = URL(string: "https://api.hypixel.net/v2/resources/skyblock/skills") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SkillsResponse.self, from: data)
            
            await MainActor.run {
                self.skillDefinitions = response.skills
                print("\(response.skills.count) Skills loaded!")
            }
        } catch {
            print("Error loading Skills: \(error)")
        }
    }
}
