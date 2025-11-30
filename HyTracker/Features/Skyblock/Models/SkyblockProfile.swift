//
//  SkyblockProfile.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation

struct SkyblockProfile: Decodable, Identifiable {
    let profileId: String
    let cuteName: String
    let selected: Bool
    let members: [String: SkyblockMember]?
    let banking: BankingInfo?
    
    var id: String { profileId }
    
    enum CodingKeys: String, CodingKey {
        case profileId = "profile_id"
        case cuteName = "cute_name"
        case selected, members, banking
    }
}

struct BankingInfo: Decodable {
    let balance: Double?
}
