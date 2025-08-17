//
//  Phase3IntroView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct Phase3IntroView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.orange)
                .shadow(radius: 10)
            
            VStack(spacing: 20) {
                Text("🌟 Fase 3 - A Jornada Final 🌟")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Parabéns por chegar até aqui!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Você já completou duas fases incríveis da experiência RodaRico. Agora é hora da fase final!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }

            VStack(spacing: 16) {
                Button("CONTINUAR") {
                    viewModel.navigateToPhase3Questions()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.green)
                .font(.headline)
                .shadow(radius: 5)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.orange)
            }
        }
    }
}

#Preview {
    NavigationView {
        Phase3IntroView(viewModel: StartGameViewModel())
    }
}
