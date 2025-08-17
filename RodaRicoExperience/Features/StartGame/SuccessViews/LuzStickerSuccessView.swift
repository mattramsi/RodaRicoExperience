//
//  LuzStickerSuccessView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct LuzStickerSuccessView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("Sticker Luz Detectado!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("A luz foi acesa e sua jornada começou!")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                
                Text("Muito Bem! Agora vamos iniciar a primeira parte da missão, respondendo nosso quiz")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Continuar") {
                    onDismiss()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.green)
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
    LuzStickerSuccessView(onDismiss: {})
}
