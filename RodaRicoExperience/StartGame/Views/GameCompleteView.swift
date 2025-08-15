//
//  GameCompleteView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct GameCompleteView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success Icon
            Image(systemName: "trophy.fill")
                .font(.system(size: 100))
                .foregroundColor(.yellow)
                .shadow(radius: 10)
            
            // Congratulations Text
            VStack(spacing: 16) {
                Text("🎉 Parabéns! 🎉")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Você completou com sucesso a experiência RodaRico!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Game Summary
            VStack(spacing: 20) {
                Text("Resumo da Jornada")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("Fase 1: Luz Acesa")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(.pink)
                        Text("Fase 2: Maquiagem Aplicada")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.blue)
                        Text("Perguntas Respondidas")
                            .font(.headline)
                        Spacer()
                        Text("6/6")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
            }
            
            // Final Message
            VStack(spacing: 12) {
                Text("Sua transformação está completa!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                
                Text("Você demonstrou dedicação, atenção aos detalhes e perseverança em completar todas as missões.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                Button("Jogar Novamente") {
                    viewModel.resetGame()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(12)
                .font(.headline)
                
                Button("Voltar ao Início") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.blue)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .font(.headline)
            }
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    NavigationView {
        GameCompleteView(viewModel: StartGameViewModel())
    }
}
