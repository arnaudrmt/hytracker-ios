//
//  Env.swift
//  HyTracker
//
//  Created by Arnaud on 30/11/2025.
//

import Foundation

struct Env {
    static var hypixelApiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "HypixelApiKey") as? String else {
            fatalError("ERROR: The Hypixel API Key is missing from Info.plist or Secrets.xcconfig")
        }
        return key
    }
}
