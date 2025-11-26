//
//  ContentView.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @EnvironmentObject var viewModel: PlayerViewModel
    @Environment(\.modelContext) var context
    @Query(sort: \RecentPlayer.viewedAt, order: .reverse) var recentPlayers: [RecentPlayer]
    
    @State private var searchField: String = ""
    @State private var navigateToProfile: Bool = false
    @State private var isSearching: Bool = false
    
    var searchHistory: Set<RecentPlayer> = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(colors: [Color("HypixelGold"), Color("HypixelOrange")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack {
                        Image("HypixelLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        
                        Text("HyTracker")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 50)
                    
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.gray)
                            
                            TextField("Minecraft Username...", text: $searchField)
                                .autocorrectionDisabled()
                                .submitLabel(.search)
                                .onSubmit {
                                    performSearch(name: searchField)
                                }
                            
                            if isSearching {
                                ProgressView()
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        
                        Button {
                            performSearch(name: searchField)
                        } label: {
                            Text("Look Up")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundStyle(.white)
                                .cornerRadius(15)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
                    if !recentPlayers.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text("Recently viewed")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.9))
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(recentPlayers) { player in
                                        Button {
                                            performSearch(name: player.playerName)
                                        } label: {
                                            VStack {
                                                AsyncImage(url: URL(string: "https://avatar.kalifondation.fr/renders/head/\(player.playerUUID)?overlay")) { img in
                                                    img.resizable().interpolation(.none)
                                                } placeholder: { Color.white.opacity(0.3) }
                                                .frame(width: 50, height: 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .shadow(radius: 3)
                                                
                                                Text(player.playerName)
                                                    .font(.caption)
                                                    .bold()
                                                    .foregroundStyle(.white)
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 70)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text("HYPIXEL NETWORK")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.7))
                            .tracking(2)
                        
                        HStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                                .shadow(color: .green, radius: 5)
                            
                            Text("\(viewModel.serverPlayerCount)")
                                .font(.system(size: 40, weight: .heavy, design: .monospaced))
                                .foregroundStyle(.white)
                            
                            Text("PLAYERS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.7))
                                .padding(.top, 10)
                        }
                        
                        Text("ONLINE NOW")
                            .font(.caption2)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(20)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                    .onAppear() {
                        viewModel.fetchServerStatus()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToProfile) {
                PlayerProfileView()
            }
            .alert("Error", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil})) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occured")
            }
        }
    }
    
    func performSearch(name: String) {
        guard !name.isEmpty else { return }
        
        isSearching = true
        
        viewModel.reset()
        
        Task {
            
            await viewModel.findPlayer(name: name)
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            isSearching = false
            
            try? await Task.sleep(nanoseconds: 100_000_000)
            
            if viewModel.errorMessage == nil && !viewModel.hypixelName.isEmpty {
                addToHistory(name: viewModel.playerName, uuid: viewModel.playerUUID)
                navigateToProfile = true
            }
        }
    }
    
    func addToHistory(name: String, uuid: String) {
        
        if let exisingPlayer = recentPlayers.first(where: { $0.playerUUID == uuid }) {
            context.delete(exisingPlayer)
        }
        
        let newEntry = RecentPlayer(playerUUID: uuid, playerName: name, viewedAt: Date())
        context.insert(newEntry)
    }
}
