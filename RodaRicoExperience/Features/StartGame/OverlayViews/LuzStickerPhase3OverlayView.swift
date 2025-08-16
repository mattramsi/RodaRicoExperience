//
//  LuzStickerPhase3OverlayView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct LuzStickerPhase3OverlayView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack {
            // Status indicator
            HStack {
                Spacer()
                VStack {
                    Circle()
                        .fill(viewModel.isTrackingActive ? Color.orange : Color.red)
                        .frame(width: 20, height: 20)
                    Text(viewModel.isTrackingActive ? "Detectando" : "Procurando")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .padding()
            }
            
            Spacer()
            
            // Instructions
            VStack(spacing: 16) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Fase 3 - Aponte para o Sticker 'Luz'")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Esta é a fase final da experiência RodaRico!")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                
                Text("Detecções: \(viewModel.detectionCount)")
                    .font(.title3)
                    .foregroundColor(.orange)
                    .padding(.top, 10)
                
                // Phase 3 specific info
                VStack(spacing: 8) {
                    Text("🌟 Fase Final")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("Após detectar a luz, você responderá as últimas 3 perguntas e acessará uma experiência AR especial!")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color.orange.opacity(0.2))
                .cornerRadius(10)
                
                // Reset Button
                Button("Reset AR Session") {
                    viewModel.resetARSession()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.top, 10)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding()
        }
    }
}

#Preview {
    LuzStickerPhase3OverlayView(viewModel: StartGameViewModel())
}
