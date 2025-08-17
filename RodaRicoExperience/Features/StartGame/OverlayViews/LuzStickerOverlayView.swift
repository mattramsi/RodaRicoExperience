//
//  LuzStickerOverlayView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct LuzStickerOverlayView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                
                Text("Aponte sua câmera para o sticker 'Luz'")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Esta é a primeira missão da experiência RodaRico")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    LuzStickerOverlayView(viewModel: StartGameViewModel())
}
