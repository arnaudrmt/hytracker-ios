//
//  HyTrackerApp.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import SwiftUI
import SwiftData

@main
struct HyTrackerApp: App {
    
    @StateObject var viewModel = PlayerViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(viewModel)
        }
        .modelContainer(for: RecentPlayer.self)
    }
}
