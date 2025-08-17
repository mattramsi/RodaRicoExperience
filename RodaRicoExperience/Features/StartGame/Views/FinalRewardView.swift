//
//  FinalRewardView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct FinalRewardView: View {
    @ObservedObject var viewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // UI Overlay
            ARContainerFinalOverlayView(viewModel: viewModel)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    NavigationView {
        FinalRewardView(viewModel: StartGameViewModel())
    }
}
