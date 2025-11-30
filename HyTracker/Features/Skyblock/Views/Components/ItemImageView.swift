//
//  ItemImageView.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ItemImageView: View {
    let itemID: String
    
    var imageURL: URL? {
        return URL(string: "https://sky.shiiyu.moe/assets/resourcepacks/Vanilla/assets/firmskyblock/models/item/\(itemID.lowercased()).png")
    }
    
    var body: some View {
        WebImage(url: imageURL)
            .resizable()
            .interpolation(.none)
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
    }
}
