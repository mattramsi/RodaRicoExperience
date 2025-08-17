//
//  MaquiagemStickerOverlayView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct MaquiagemStickerOverlayView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.pink)
                
                Text("Aponte sua câmera para o sticker 'Maquiagem'")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Esta é a segunda missão da experiência RodaRico")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding()
        }
    }
}

#Preview {
    MaquiagemStickerOverlayView(viewModel: StartGameViewModel())
}
