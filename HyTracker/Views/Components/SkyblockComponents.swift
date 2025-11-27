//
//  SkyblockComponents.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

struct ProfileHeaderView: View {
    
    let profileName: String
    let sbLevelXP: Double
    let fairySouls: Int
    let purse: Double
    let skillAvg: Double
    
    var sbLevel: Int { Int(sbLevelXP / 100) }
    var sbProgress: Double { (sbLevelXP.truncatingRemainder(dividingBy: 100)) / 100 }
    var joinedDate: Double?
    
    let onInfoTap: () -> Void
    
    var formattedDate: String {
        guard let timestamp = joinedDate else { return "N/A" }
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            
            Image("skyblock_head_globe")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.indigo)
                .frame(width: 50, height: 50)
                .background(Color.indigo.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(profileName)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.bank.building.fill").foregroundStyle(.yellow)
                        Text(purse.abbreviated()).bold().foregroundStyle(.primary)
                    }
                    .font(.caption)
                    .padding(6)
                    .background(Color.yellow.opacity(0.15))
                    .cornerRadius(8)
                    
                    Button(action: onInfoTap) {
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                    .padding(.leading, 5)
                }
                
                HStack(spacing: 5) {
                    Text("Lvl \(sbLevel)")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.pink)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.gray.opacity(0.2))
                            Capsule().fill(Color.pink).frame(width: geo.size.width * sbProgress)
                        }
                    }
                    .frame(height: 6)
                }
                
                HStack(spacing: 15) {
                    Label("\(fairySouls) Souls", systemImage: "sparkles")
                    Label("SA: \(String(format: "%.1f", skillAvg))", systemImage: "chart.bar")
                    Label(formattedDate, systemImage: "calendar")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct SkillRowView: View {
    let type: SkyblockModuleType
    let xp: Double
    
    var info: SkyblockCalculator.SkillInfo {
        SkyblockCalculator.calculateSkillLevel(xp: xp, type: type)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            
            Group {
                if type.isAsset {
                    Image(type.iconName)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                } else {
                    Image(systemName: "cube.fill")
                }
            }
            .frame(width: 32, height: 32)
            .shadow(color: type.color.opacity(0.4), radius: 2, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(type.title)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text("Lvl \(info.level)")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(type.color)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.5))
                        
                        Capsule()
                            .fill(
                                LinearGradient(colors: [type.color, type.color.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
                            )
                            .frame(width: geo.size.width * info.progress)
                    }
                }
                .frame(height: 6)
                
                HStack {
                    if info.progress >= 1.0 {
                        Text("MAXED")
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(type.color)
                    } else {
                        Text("\(info.currentXP.abbreviated()) / \(info.goalXP.abbreviated()) XP")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(Int(info.progress * 100))%")
                        .font(.caption2)
                        .bold()
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                colors: [type.color.opacity(0.15), type.color.opacity(0.02)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(type.color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ModuleButton: View {
    let type: SkyblockModuleType
    
    var body: some View {
        VStack(spacing: 12) {
            Group {
                if type.isAsset {
                    Image(type.iconName)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                } else {
                    Image(systemName: type.iconName)
                        .font(.title)
                        .foregroundStyle(type.color)
                        .frame(width: 40, height: 40)
                }
            }
            .padding(10)
            .background(type.color.opacity(0.1))
            .clipShape(Circle())
            
            Text(type.title)
                .font(.caption)
                .bold()
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct StatBoxView: View {
    let icon: SBIcon
    let name: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                icon.view(size: 14, color: color)
                
                Text(name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            .foregroundStyle(color)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

struct StatSectionView<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                Text(title.uppercased())
            }
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(color.opacity(0.8))
            .padding(.leading, 5)
            
            LazyVGrid(columns: columns, spacing: 10) {
                content
            }
        }
        .padding(.bottom, 15)
    }
}
