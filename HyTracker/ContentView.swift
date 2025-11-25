//
//  ContentView.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var viewModel: PlayerViewModel
    @Environment(\.modelContext) var context
    @State var searchField: String = ""
    @Query(sort: \RecentPlayer.viewedAt, order: .reverse) var recentPlayers: [RecentPlayer]
    
    var searchHistory: Set<RecentPlayer> = []
    
    var body: some View {
        
        VStack {
            
            if (viewModel.hypixelName.isEmpty) {
                TextField("Search for a player", text: $searchField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocorrectionDisabled()
                
                Button {
                    Task {
                        viewModel.findPlayer(name: searchField)
                    }
                } label: {
                    Text("Search")
                }
                
                if !recentPlayers.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Recent Searches")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.leading, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(recentPlayers) { player in
                                    Button {
                                        viewModel.findPlayer(name: player.playerName)
                                    } label: {
                                        VStack {
                                            AsyncImage(url: URL(string: "https://avatar.kalifondation.fr/renders/head/\(player.playerUUID)?overlay")) { img in
                                                img.resizable().interpolation(.none)
                                            } placeholder: {
                                                Color.gray
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            Text(player.playerName)
                                                .font(.caption2)
                                                .foregroundStyle(.primary)
                                                .lineLimit(1)
                                        }
                                        .frame(width: 60)
                                    }
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                    .padding(.bottom, 10)
                }
                
            } else {
                
                VStack(spacing: 15) {
                    HStack(spacing: 20) {
                        
                        AsyncImage(url: URL(string: "https://avatar.kalifondation.fr/renders/head/\(viewModel.playerUUID)?overlay")) { phase in
                            if let image = phase.image {
                                image.resizable().interpolation(.none)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 80, height: 80)
                        .shadow(radius: 5)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            HStack {
                                if let player = viewModel.hypixelPlayer, !player.formattedRank.isEmpty {
                                    Text(player.formattedRank)
                                        .font(.title2)
                                        .fontWeight(.black)
                                        .foregroundStyle(player.rankColor)
                                        .layoutPriority(1)
                                }
                                
                                Text("\(viewModel.hypixelName)")
                                    .font(.title2)
                                    .fontWeight(.black)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                            }
                            .minimumScaleFactor(0.6)
                            
                            let progress = viewModel.hypixelLevel.truncatingRemainder(dividingBy: 1)
                            
                            Text("Level \(Int(viewModel.hypixelLevel))")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            ProgressView(value: progress)
                                .tint(.yellow)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.reset()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.gray.opacity(0.6))
                            .padding(10)
                    }
                }
                .padding()
                
                Spacer()
                
                Text("Games")
                    .fontWeight(.bold)
                
                let columns = [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ]
                
                LazyVGrid(columns: columns, spacing: 20) {
                    GameCardView(title: "Bedwars", imageName: "bed.double.fill", color: .red, mainStat: "\(viewModel.bedwarsWins) Wins", subStat: "\(String(format: "%.2f", viewModel.bedwarsKD)) K/D")
                    
                    GameCardView(title: "SkyWars", imageName: "cloud.fill", color: .blue, mainStat: "\(viewModel.skyWarsWins) Wins", subStat: "\(String(format: "%.2f", viewModel.skyWarsKD)) K/D")
                }
            }
        }
        .padding()
        .onChange(of: viewModel.hypixelName) { _, newUUID in
            if !newUUID.isEmpty && viewModel.hypixelPlayer != nil {
                addToHistory(name: viewModel.playerName, uuid: viewModel.playerUUID)
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

struct GameCardView: View {
    
    let title: String
    let imageName: String
    let color: Color
    let mainStat: String
    let subStat: String
    
    var body: some View {
        VStack(spacing: 10) {
            
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(color)
                Text(title)
                    .fontWeight(.bold)
                Spacer()
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(mainStat)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(subStat)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
