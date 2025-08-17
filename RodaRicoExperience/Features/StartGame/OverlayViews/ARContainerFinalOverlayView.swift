//
//  ARContainerFinalOverlayView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct ARContainerFinalOverlayView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                
                Text("Parabéns! Você completou toda a experiência RodaRico!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
    
                Button("🎁  Continuar") {
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
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding()
        }
    }
}

#Preview {
    ARContainerFinalOverlayView(viewModel: StartGameViewModel())
}
