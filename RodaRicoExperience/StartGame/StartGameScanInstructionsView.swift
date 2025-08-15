//
//  StartGameScanInstructionsView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct StartGameScanInstructionsView: View {
    @Binding var isVisible: Bool
    let onStartScanning: () -> Void
    
    var body: some View {
        ZStack {
            // Background Overlay
            BackgroundOverlayView(isVisible: $isVisible)
            
            // Modal Content
            ModalContentView(
                isVisible: $isVisible,
                onStartScanning: onStartScanning
            )
        }
    }
}

// MARK: - Background Overlay Component
private struct BackgroundOverlayView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                isVisible = false
            }
    }
}

// MARK: - Modal Content Component
private struct ModalContentView: View {
    @Binding var isVisible: Bool
    let onStartScanning: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HeaderView()
            
            // Instructions Text
            InstructionsTextView()
            
            // Action Button
            ActionButtonView(onStartScanning: onStartScanning)
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

// MARK: - Header Component
private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Primeira Missão")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Instructions Text Component
private struct InstructionsTextView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Bem-vindo à primeira missão da experiência RodaRico!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Você precisa escanear o sticker 'Luz' para acender a primeira luz da sua aventura. Este é o início de uma jornada incrível!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("Dica: Mantenha o sticker estável e bem iluminado para uma detecção mais rápida.")
                .font(.subheadline)
                .foregroundColor(.yellow)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }
}

// MARK: - Action Button Component
private struct ActionButtonView: View {
    let onStartScanning: () -> Void
    
    var body: some View {
        Button(action: onStartScanning) {
            HStack {
                Text("Começar Missão")
                    .fontWeight(.semibold)
                
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.yellow, .orange],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
    }
}

#Preview {
    StartGameScanInstructionsView(
        isVisible: .constant(true),
        onStartScanning: {}
    )
}
