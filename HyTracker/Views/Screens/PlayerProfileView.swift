//
//  PlayerProfileView.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

struct PlayerProfileView: View {
    
    @EnvironmentObject var viewModel: PlayerViewModel
    
    @State private var selectedTab = 0
    @State private var selectedGame: GameType? = nil
    @State private var selectedProfile: HypixelAPI.SkyblockProfile? = nil
    
    var themeColor: Color {
        return viewModel.hypixelPlayer?.rankColor ?? .blue
    }
    
    var body: some View {
        ScrollView() {
            VStack(spacing: 20) {
                
                headerSection
                
                Picker("Mode", selection: $selectedTab) {
                    Text("General").tag(0)
                    Text("Skyblock").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if selectedTab == 0 {
                    generalGamesGrid
                } else {
                    skyblockPlaceholder
                }
            }
            .padding(.bottom)
        }
        .background(
            ZStack {
                Color(.systemGroupedBackground)
                
                LinearGradient(
                    colors: [themeColor.opacity(0.5), Color(.systemGroupedBackground)], startPoint: .top, endPoint: .center)
                .ignoresSafeArea()
            }
        )
        .navigationTitle(viewModel.playerName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedGame) { game in
            GameDetailView(game: game)
        }
    }
    
    var headerSection: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: "https://avatar.kalifondation.fr/renders/head/\(viewModel.playerUUID)?overlay")) { img in
                img.image?.resizable().interpolation(.none)
            }
            .frame(width: 80, height: 80)
            .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    if let player = viewModel.hypixelPlayer, !player.formattedRank.isEmpty {
                        Text(player.formattedRank)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(player.rankColor)
                            .layoutPriority(1)
                    }
                    Text(viewModel.hypixelName)
                        .font(.title)
                        .fontWeight(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                }
                
                Text("Level \(Int(viewModel.hypixelLevel))")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                ProgressView(value: viewModel.hypixelLevel.truncatingRemainder(dividingBy: 1))
                    .tint(.yellow)
                
                if let gName = viewModel.guildName {
                    Text("\(gName) \(viewModel.guildTag != nil ? "[\(viewModel.guildTag!)]" : "")")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.purple)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
    
    var generalGamesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            
            
            Button { selectedGame = .bedwars } label: {
                GameCardView(title: "Bedwars", imageName: "icon_bed", color: .red, mainStat: "\(viewModel.bedwarsWins) Wins", subStat: "\(String(format: "%.2f", viewModel.bedwarsKD)) K/D")
            }
            
            Button { selectedGame = .skywars } label: {
                GameCardView(title: "SkyWars", imageName: "icon_eye", color: .blue, mainStat: "\(viewModel.skyWarsWins) Wins", subStat: "\(String(format: "%.2f", viewModel.skyWarsKD)) K/D")
            }
            
            Button { selectedGame = .duels } label: {
                GameCardView(title: "Duels", imageName: "icon_fishing_rod", color: .orange, mainStat: "\(viewModel.duelsWins) Wins", subStat: "\(String(format: "%.2f", viewModel.duelsKD)) K/D")
            }
            
            Button { selectedGame = .murderMystery } label: {
                GameCardView(title: "Murder Mystery", imageName: "icon_bow", color: .purple, mainStat: "\(viewModel.mmWins) Wins", subStat: "\(viewModel.mmKils) Kills")
            }
        }
        .padding()
    }
    
    var skyblockPlaceholder: some View {
        VStack(spacing: 15) {
            
            HStack{
                Text("Profiles")
                    .font(.headline)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.horizontal)
            
            if viewModel.skyblockProfiles.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "slash.circle")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                    
                    Text("No Skyblock profiles found. Try again later.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 30)
            } else {
                ForEach(viewModel.skyblockProfiles) { profile in
                    Button {
                        selectedProfile = profile
                    } label: {
                        SkyblockProfileViewRow(profile: profile)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .fullScreenCover(item: $selectedProfile) { profile in
            SkyblockDashboardView(profile: profile, playerUUID: viewModel.playerUUID)
        }
    }
}

struct SkyblockProfileViewRow: View {
    let profile: HypixelAPI.SkyblockProfile
    
    var body: some View {
        HStack(spacing: 15) {
            
            Image(systemName: "tree.fill")
                .font(.title)
                .foregroundStyle(profile.selected ? .indigo : .gray)
                .frame(width: 50, height: 50)
                .background(profile.selected ? .indigo.opacity(0.1) : .gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                Text(profile.cuteName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("ID: ...\(profile.profileId.suffix(4))")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .monospaced()
            }
            
            Spacer()
            
            if profile.selected {
                Text("ACTIF")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.indigo)
                    .clipShape(Capsule())
                    .shadow(color: .indigo.opacity(0.3), radius: 3)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
