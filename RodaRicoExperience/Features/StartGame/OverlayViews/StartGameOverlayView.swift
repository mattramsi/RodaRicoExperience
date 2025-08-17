//
//  StartGameOverlayView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct StartGameOverlayView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.pink)
                
                Text("Para iniciar a nossa missão, escaneie o Adesivo de Fone")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button("CONTINUAR") {
                    viewModel.currentView = .startGame
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.green)
                .font(.headline)
                .shadow(radius: 5)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
        }
    }
}

#Preview {
    StartGameOverlayView(viewModel: StartGameViewModel())
        .background(Color.black)
}

