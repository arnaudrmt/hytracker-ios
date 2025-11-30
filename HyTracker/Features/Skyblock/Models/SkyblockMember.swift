//
//  SkyblockMember.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation

struct SkyblockMember: Decodable {
    let currencies: Currencies?
    let playerData: PlayerData?
    let leveling: LevelingInfo?
    let fairySoul: FairySoulInfo?
    let profileData: MemberProfileData?
    let collection: [String: Int]?
    let petsData: PetsData?
    let inventory: InventoryData?
    
    enum CodingKeys: String, CodingKey {
        case currencies, leveling, inventory, collection
        case playerData = "player_data"
        case fairySoul = "fairy_soul"
        case profileData = "profile"
        case petsData = "pets_data"
    }
}

struct Currencies: Decodable {
    let coinPurse: Double?
    enum CodingKeys: String, CodingKey {
        case coinPurse = "coin_purse"
    }
}

struct PlayerData: Decodable {
    let experience: [String: Double]?
    let craftedGenerators: [String]?
    
    var combatXP: Double? { experience?["SKILL_COMBAT"] }
    var miningXP: Double? { experience?["SKILL_MINING"] }
    var farmingXP: Double? { experience?["SKILL_FARMING"] }
    var foragingXP: Double? { experience?["SKILL_FORAGING"] }
    var fishingXP: Double? { experience?["SKILL_FISHING"] }
    var enchantingXP: Double? { experience?["SKILL_ENCHANTING"] }
    var alchemyXP: Double? { experience?["SKILL_ALCHEMY"] }
    var tamingXP: Double? { experience?["SKILL_TAMING"] }
    var runecraftingXP: Double? { experience?["SKILL_RUNECRAFTING"] }
    var socialXP: Double? { experience?["SKILL_SOCIAL"] }
    var carpentryXP: Double? { experience?["SKILL_CARPENTRY"] }
    
    enum CodingKeys: String, CodingKey {
            case experience
            case craftedGenerators = "crafted_generators"
        }
}

struct LevelingInfo: Decodable {
    let experience: Double?
}


struct FairySoulInfo: Decodable {
    let totalCollected: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalCollected = "total_collected"
    }
}

struct MemberProfileData: Decodable {
    let firstJoin: Double?
    
    enum CodingKeys: String, CodingKey {
        case firstJoin = "first_join"
    }
}

struct PetsData: Decodable {
    let pets: [Pet]?
}

struct Pet: Decodable, Identifiable {
    let uuid: String?
    let type: String
    let exp: Double
    let active: Bool
    let tier: String
    let candyUsed: Int
    let skin: String?
    let heldItem: String?
    
    var id: String { uuid ?? UUID().uuidString }
    
    enum CodingKeys: String, CodingKey {
        case uuid, type, exp, active, tier, skin, heldItem
        case candyUsed = "candyUsed"
    }
}

struct InventoryData: Decodable {
    let armor: InvContents?
    let equipment: InvContents?
    let wardrobe: InvContents?
    
    enum CodingKeys: String, CodingKey {
        case armor = "inv_armor"
        case equipment = "equipment_contents"
        case wardrobe = "wardrobe_contents"
    }
}

struct InvContents: Decodable {
    let type: Int?
    let data: String?
}

