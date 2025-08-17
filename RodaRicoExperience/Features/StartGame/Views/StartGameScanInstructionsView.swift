//
//  StartGameScanInstructionsView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct StartGameScanInstructionsView: View {
    let onStartScanning: () -> Void
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // Background Overlay
            BackgroundOverlayView()
            
            // Modal Content
            ModalContentView(
                onStartScanning: onStartScanning,
                viewModel: viewModel
            )
        }
    }
}

// MARK: - Background Overlay Component
private struct BackgroundOverlayView: View {
    
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Modal Content Component
private struct ModalContentView: View {
    let onStartScanning: () -> Void
    let viewModel: StartGameViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HeaderView()
                
                // Timer da Missão
                MissionTimerView(
                    timeRemaining: viewModel.timeRemaining,
                    isTimerRunning: viewModel.isTimerRunning
                )
                
                // Instructions Text
                InstructionsTextView()
                
                // Action Button
                ActionButtonView(onStartScanning: onStartScanning)
            }
            .padding(32)
        }
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(radius: 20)
        .scaleEffect(1.0)
        .opacity(1.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: true)
    }
}

// MARK: - Header Component
private struct HeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("🚨 MISSÃO CRÍTICA 🚨")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
        }
    }
}

// MARK: - Instructions Text Component
private struct InstructionsTextView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("💣 BOMBA ARMADA DETECTADA! 💣")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            
            Text("Bandidos armadilharam uma bomba no local e você é nossa única esperança para desarmá-la!")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("⏰ Você tem APENAS 10 MINUTOS para desarmar a bomba antes que ela exploda!")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("🔍 Para desarmar a bomba, você deve:")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text("1.")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Escaneie o primeiro componente (Luz)")
                        .foregroundColor(.primary)
                }
                
                HStack(alignment: .top) {
                    Text("2.")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Responda as perguntas de segurança")
                        .foregroundColor(.primary)
                }
                
                HStack(alignment: .top) {
                    Text("3.")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Repita para os outros componentes")
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("⚠️ ATENÇÃO: Cada resposta errada custa 30 segundos do seu tempo!")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("🎯 Dica: Mantenha o sticker estável e bem iluminado para uma detecção mais rápida.")
                .font(.subheadline)
                .foregroundColor(.blue)
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
                Text("🚨 INICIAR DESARMA DA BOMBA")
                    .fontWeight(.bold)
                
                Image(systemName: "bolt.fill")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.red, .orange],
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
        onStartScanning: {},
        viewModel: StartGameViewModel()
    )
}
