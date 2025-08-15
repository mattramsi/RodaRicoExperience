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
            // Status indicator
            HStack {
                Spacer()
                VStack {
                    Circle()
                        .fill(viewModel.isTrackingActive ? Color.green : Color.red)
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
                
                Text("Detecções: \(viewModel.detectionCount)")
                    .font(.title3)
                    .foregroundColor(.pink)
                    .padding(.top, 10)
                
                // Reset Button
                Button("Reset AR Session") {
                    print("🔄 User requested AR session reset")
                    viewModel.resetARSession()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.top, 10)
                
                // Status Info
                Text("Status: \(viewModel.isTrackingActive ? "Ativo" : "Inativo")")
                    .font(.caption)
                    .foregroundColor(viewModel.isTrackingActive ? .green : .red)
                    .padding(.top, 5)
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
