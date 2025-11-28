//
//  GameDetailView.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

struct GameDetailView: View {
    
    @EnvironmentObject var viewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    
    let game: GameType
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    colors: [game.color.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        HStack {
                            Image(game.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(game.color)
                                .padding()
                                .background(game.color.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack {
                                Text(game.title)
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                                
                                Text("Detailed Stats")
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        
                        contentForGame(game)
                    }
                    .padding(.vertical)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.gray)
                                .font(.title2)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func contentForGame(_ game: GameType) -> some View {
        VStack(spacing: 25) {
            
            switch game {
            case .bedwars:
                
                StatsSection(title: "Performance") {
                    StatRow(title: "Games Played", value: "\(viewModel.bedwarsGamesPlayed)", icon: "gamecontroller.fill", color: .blue)
                    StatRow(title: "Wins", value: "\(viewModel.bedwarsWins)", icon: "trophy.fill", color: .green)
                    StatRow(title: "Losses", value: "\(viewModel.bedwarsLosses)", icon: "xmark.shield.fill", color: .red)
                }
                
                StatsSection(title: "Combat") {
                    StatRow(title: "Kills", value: "\(viewModel.bedwarsKills)", icon: "flame.fill", color: .orange)
                    StatRow(title: "Deaths", value: "\(viewModel.bedwarsDeaths)", icon: "figure.fall.circle.fill", color: .gray)
                    StatRow(title: "K/D Ratio", value: "\(viewModel.bedwarsKD)", icon: "divide.circle.fill", color: .yellow)
                }
               
                StatsSection(title: "Finals") {
                    StatRow(title: "Final Kills", value: "\(viewModel.bedwarsFinalKills)", icon: "bolt.fill", color: .purple)
                    StatRow(title: "Final Deaths", value: "\(viewModel.bedwarsFinalDeaths)", icon: "tornado", color: .gray)
                }
                
            case .skywars:
                
                StatsSection(title: "Performance") {
                    StatRow(title: "Games Played", value: "\(viewModel.skyWarsGamesPlayed)", icon: "gamecontroller.fill", color: .blue)
                    StatRow(title: "Wins", value: "\(viewModel.skyWarsWins)", icon: "trophy.fill", color: .green)
                    StatRow(title: "Losses", value: "\(viewModel.skyWarsLosses)", icon: "xmark.shield.fill", color: .red)
                }
                
                StatsSection(title: "Combat") {
                    StatRow(title: "Kills", value: "\(viewModel.skyWarsKills)", icon: "flame.fill", color: .purple)
                    StatRow(title: "Deaths", value: "\(viewModel.skyWarsDeaths)", icon: "figure.fall.circle.fill", color: .orange)
                    StatRow(title: "K/D Ratio", value: "\(viewModel.skyWarsKD)", icon: "divide.circle.fill", color: .yellow)
                }
                
            case .duels:
                
                StatsSection(title: "Performance") {
                    StatRow(title: "Games Played", value: "\(viewModel.duelsGamesPlayed)", icon: "gamecontroller.fill", color: .blue)
                    StatRow(title: "Wins", value: "\(viewModel.duelsWins)", icon: "trophy.fill", color: .green)
                    StatRow(title: "Losses", value: "\(viewModel.duelsLosses)", icon: "xmark.shield.fill", color: .red)
                }
                
                StatsSection(title: "Combat") {
                    StatRow(title: "Kills", value: "\(viewModel.duelsKills)", icon: "swift", color: .orange)
                    StatRow(title: "Deaths", value: "\(viewModel.duelsDeaths)", icon: "figure.fall.circle.fill", color: .gray)
                    StatRow(title: "K/D Ratio", value: "\(viewModel.duelsKD)", icon: "divide.circle.fill", color: .yellow)
                }
                
            case .murderMystery:
                
                StatsSection(title: "Performance") {
                    StatRow(title: "Games Played", value: "\(viewModel.mmGamesPlayed)", icon: "gamecontroller.fill", color: .blue)
                    StatRow(title: "Wins", value: "\(viewModel.mmWins)", icon: "trophy.fill", color: .green)
                    StatRow(title: "Losses", value: "\(viewModel.mmLosses)", icon: "xmark.shield.fill", color: .red)
                }
                
                StatsSection(title: "Combat") {
                    StatRow(title: "Kills", value: "\(viewModel.mmKils)", icon: "magnifyingglass", color: .purple)
                }
                
                StatsSection(title: "Bank") {
                    StatRow(title: "Coins", value: "\(viewModel.mmCoins)", icon: "banknote.fill", color: .yellow)
                }
            }
        }
        .padding(.horizontal)
    }
    
    struct StatsSection<Content: View>: View {
        let title: String
        @ViewBuilder let content: Content
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.leading, 5)
                
                VStack(spacing: 10) {
                    content
                }
            }
        }
    }
    
    struct StatRow: View {
        let title: String
        let value: String
        let icon: String
        let color: Color
        
        var formattedValue: String {
                guard let doubleValue = Double(value) else {
                    return value
                }
                
                if value.contains(".") {
                    return String(format: "%.2f", doubleValue)
                } else {
                    return value
                }
            }
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(color.gradient)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(formattedValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
        }
    }
}
