//
//  MissionFailedView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct MissionFailedView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Explosion Icon
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.red)
                        .scaleEffect(1.2)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: true)
                    
                    Text("💥 BOOM! 💥")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                // Mission Failed Text
                VStack(spacing: 20) {
                    Text("MISSÃO FALHOU!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Text("O tempo esgotou e a bomba explodiu!")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Você não conseguiu desarmar todos os componentes a tempo.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Timer Info
                VStack(spacing: 10) {
                    Text("⏰ TEMPO LIMITE: 10 MINUTOS")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("Você precisa ser mais rápido na próxima tentativa!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 20) {
                    Button(action: {
                        viewModel.resetGame()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                            Text("TENTAR NOVAMENTE")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                    }
                    
                    Button(action: {
                        viewModel.currentView = .initial
                    }) {
                        HStack {
                            Image(systemName: "house.fill")
                                .font(.title2)
                            Text("VOLTAR AO INÍCIO")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MissionFailedView(viewModel: StartGameViewModel())
}
