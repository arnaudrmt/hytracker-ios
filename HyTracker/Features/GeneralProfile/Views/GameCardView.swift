//
//  GameCardView.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

struct GameCardView: View {
    
    let title: String
    let imageName: String
    let color: Color
    let mainStat: String
    let subStat: String
    
    var body: some View {
        VStack(spacing: 10) {
            
            HStack {
                Image(imageName)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
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
                    
                    if subStat != "" {
                        Text(subStat)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: Color("mc_black").opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
