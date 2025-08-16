//
//  StartGameView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct StartGameView: View {
    @StateObject private var viewModel = StartGameViewModel()
    
    var body: some View {
        Group {
            let _ = print("🔄 StartGameView - currentView: \(viewModel.currentView)")
            let _ = print("🔄 StartGameView - currentPhase: \(viewModel.currentPhase)")
            
            switch viewModel.currentView {
            case .initial:
                // Initial state - welcome screen with start button
                VStack(spacing: 30) {
                    Text("Bem-vindo à Experiência RodaRico!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("Uma jornada interativa com AR e stickers")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.currentView = .startGame
                        print("🚀 Starting AR Experience")
                    }) {
                        HStack {
                            Image(systemName: "camera.viewfinder")
                                .font(.title2)
                            Text("Iniciar Experiência AR")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                }
                .navigationTitle("RodaRico")
                .navigationBarTitleDisplayMode(.inline)
                
            case .startGame:
                // AR View com modais
                ZStack {
                    // AR Container
                    StartGameARContainerView(viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                    
                    // UI Overlay
                    StartGameOverlayView(viewModel: viewModel)
                    
                    // Instructions Modal
                    if viewModel.isInstructionsVisible {
                        StartGameInstructionsModal(
                            isVisible: $viewModel.isInstructionsVisible,
                            onAdvance: viewModel.handleAdvance
                        )
                    }
                    
                    // Scan Instructions Modal
                    if viewModel.isScanInstructionsVisible {
                        StartGameScanInstructionsView(
                            isVisible: $viewModel.isScanInstructionsVisible,
                            onStartScanning: viewModel.handleStartScanning
                        )
                    }
                }
                .navigationTitle("Start Game")
                .navigationBarTitleDisplayMode(.inline)
                
            case .luzScanner:
                // Luz Scanner View
                LuzStickerScannerView(viewModel: viewModel)
                    .navigationTitle("Scanner - Sticker Luz")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .phase1Questions:
                // Phase 1 Questions View
                QuestionsPhase1View(viewModel: viewModel)
                    .navigationTitle("Fase 1 - Perguntas")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .maquiagemScanner:
                // Maquiagem Scanner View
                MaquiagemStickerScannerView(viewModel: viewModel)
                    .navigationTitle("Scanner - Sticker Maquiagem")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .phase2Questions:
                // Phase 2 Questions View
                QuestionsPhase2View(viewModel: viewModel)
                    .navigationTitle("Fase 2 - Perguntas")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .phase3Intro:
                // Phase 3 Introduction View
                Phase3IntroView(viewModel: viewModel)
                    .navigationTitle("Fase 3 - Introdução")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .luzScannerPhase3:
                // Phase 3 Luz Scanner View
                LuzStickerScannerPhase3View(viewModel: viewModel)
                    .navigationTitle("Scanner - Sticker Luz Fase 3")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .phase3Questions:
                // Phase 3 Questions View
                QuestionsPhase3View(viewModel: viewModel)
                    .navigationTitle("Fase 3 - Perguntas Finais")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .gameComplete:
                // Game Complete View
                GameCompleteView(viewModel: viewModel)
                    .navigationTitle("Jogo Concluído")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .arContainerFinal:
                // Final AR Container View
                ARContainerFinalView(viewModel: viewModel)
                    .navigationTitle("Recompensa AR Final")
                    .navigationBarTitleDisplayMode(.inline)
                
            case .arExperienceFinal:
                // Final AR Experience View with Key and Treasure
                ARExperienceView()
                    .navigationTitle("Experiência AR Final")
                    .navigationBarTitleDisplayMode(.inline)
                
            // Switch é exaustivo, não precisa de default case
            }
        }
    }
}

#Preview {
    NavigationView {
        StartGameView()
    }
}

