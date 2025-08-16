//
//  MaquiagemStickerSuccessView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct MaquiagemStickerSuccessView: View {
    @Binding var isVisible: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isVisible = false
                }
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.pink)
                
                Text("Sticker Maquiagem Detectado!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Parabéns! Você completou a segunda missão da experiência RodaRico.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("A maquiagem foi aplicada e você está mais bonito(a)!")
                    .font(.subheadline)
                    .foregroundColor(.pink)
                    .multilineTextAlignment(.center)
                
                Button("Continuar") {
                    isVisible = false
                    onDismiss()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.pink)
                .cornerRadius(12)
            }
            .padding(32)
            .background(Color(.systemBackground))
            .cornerRadius(24)
            .shadow(radius: 20)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isVisible)
        }
    }
}

#Preview {
    MaquiagemStickerSuccessView(isVisible: .constant(true), onDismiss: {})
}
