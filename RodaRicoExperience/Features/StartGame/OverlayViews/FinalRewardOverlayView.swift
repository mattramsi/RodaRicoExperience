//
//  FinalRewardOverlayView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct FinalRewardOverlayView: View {
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
            
            // Final Reward Instructions
            VStack(spacing: 20) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                
                Text("🎊 Recompensa Final - AR Experience 🎊")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Parabéns! Você completou toda a experiência RodaRico!")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                
                // Final instructions
                VStack(spacing: 16) {
                    Text("🎯 Como usar sua recompensa:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    VStack(spacing: 12) {
                        HStack(alignment: .top) {
                            Image(systemName: "1.circle.fill")
                                .foregroundColor(.orange)
                            Text("Aponte para o sticker 'Luz' para ativar efeitos especiais")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "2.circle.fill")
                                .foregroundColor(.orange)
                            Text("Aponte para o sticker 'Maquiagem' para mais celebrações")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "3.circle.fill")
                                .foregroundColor(.orange)
                            Text("Explore os efeitos visuais e mensagens de celebração")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(15)
                }
                
                // Stats
                VStack(spacing: 8) {
                    Text("📊 Suas Conquistas:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(viewModel.phase1CorrectAnswers)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("Fase 1")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        VStack {
                            Text("\(viewModel.phase2CorrectAnswers)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.pink)
                            Text("Fase 2")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        VStack {
                            Text("\(viewModel.phase3CorrectAnswers)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text("Fase 3")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(15)
                }
                
                // Continue to Final Experience Button
                Button("🎁 Continuar para Experiência Final - Chave e Baú") {
                    viewModel.navigateToARExperienceFinal()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(Color.orange)
                .cornerRadius(12)
                .font(.headline)
                .shadow(radius: 5)
                .padding(.top, 20)
                
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
    FinalRewardOverlayView(viewModel: StartGameViewModel())
}
