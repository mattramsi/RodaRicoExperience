//
//  LuzStickerPhase3SuccessView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct LuzStickerPhase3SuccessView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                
                Text("🌟 Fase 3 - Luz Detectada! 🌟")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Incrível! Você chegou à fase final da experiência RodaRico!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Agora é hora de responder as últimas 3 perguntas e desbloquear sua recompensa especial!")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                
                // Phase 3 specific message
                VStack(spacing: 8) {
                    Text("🎯 Próximo Passo:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("Responda as perguntas finais para acessar uma experiência AR única!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                
                Button("Continuar para as Perguntas") {
                    onDismiss()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.orange)
                .cornerRadius(12)
            }
            .padding(32)
            .background(Color(.systemBackground))
            .cornerRadius(24)
            .shadow(radius: 20)
            .scaleEffect(1.0)
            .opacity(1.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: true)
        }
    }
}

#Preview {
    LuzStickerPhase3SuccessView(onDismiss: {})
}
