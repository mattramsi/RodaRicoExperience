//
//  StartGameViewModel.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

@MainActor
final class StartGameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isInstructionsVisible = false
    @Published var isScanInstructionsVisible = false
    @Published var isTrackingActive = false
    @Published var detectionCount = 0
    @Published var isSuccessVisible = false
    
    // Estados das views - Centralizado para todas as mudanças de tela
    @Published var currentView: StartGameViewState = .initial
    
    // Estados das fases
    @Published var currentPhase: GamePhase = .initial
    @Published var phase1CorrectAnswers = 0
    @Published var phase2CorrectAnswers = 0
    @Published var phase3CorrectAnswers = 0
    
    // MARK: - Private Properties
    private var hasShownInstructions = false
    
    // MARK: - Public Methods
    func handleRocketDetection() {
        detectionCount += 1
        
        if !hasShownInstructions {
            showInstructions()
        }
    }
    
    func handleAdvance() {
        hideInstructions()
        showScanInstructions()
    }
    
    func handleStartScanning() {
        hideScanInstructions()
        // Fechar o AR e abrir o scanner do sticker "luz"
        currentView = .luzScanner
        print("🚀 Closing AR and opening Luz Sticker Scanner")
    }
    
    func goBackToAR() {
        // Resetar o sistema para voltar ao AR
        isInstructionsVisible = false
        isScanInstructionsVisible = false
        isTrackingActive = false
        currentView = .startGame
        print("🔙 Going back to AR View - System reset")
    }
    
    func resetARSession() {
        print("🔄 Manual AR Session reset requested from ViewModel")
        // Aqui você pode adicionar lógica adicional se necessário
        // O reset real é feito pelo coordinator
    }
    
    // MARK: - Navigation Methods
    func navigateToPhase1Questions() {
        currentView = .phase1Questions
        print("📝 Navigating to Phase 1 Questions")
    }
    
    func navigateToMaquiagemScanner() {
        currentView = .maquiagemScanner
        print("💄 Navigating to Maquiagem Scanner")
    }
    
    func navigateToPhase2Questions() {
        currentView = .phase2Questions
        print("📝 Navigating to Phase 2 Questions")
    }
    
    func navigateToGameComplete() {
        currentView = .gameComplete
        print("🎉 Game completed! Navigating to completion screen")
    }
    
    func navigateToPhase3Intro() {
        print("🔄 navigateToPhase3Intro() chamado")
        print("📍 Estado atual: \(currentView)")
        print("📍 Fase atual: \(currentPhase)")
        
        currentView = .phase3Intro
        currentPhase = .phase3Intro
        
        print("✅ Estado alterado para: \(currentView)")
        print("✅ Fase alterada para: \(currentPhase)")
        print("🌟 Navigating to Phase 3 Introduction")
    }
    
    func navigateToLuzScannerPhase3() {
        currentView = .luzScannerPhase3
        print("💡 Navigating to Phase 3 Luz Scanner")
    }
    
    func navigateToPhase3Questions() {
        currentView = .phase3Questions
        print("📝 Navigating to Phase 3 Questions")
    }
    
    func navigateToARContainerFinal() {
        currentView = .arContainerFinal
        print("🎯 Navigating to Final AR Container")
    }
    
    func navigateToARExperienceFinal() {
        currentView = .arExperienceFinal
        print("🎊 Navigating to Final AR Experience with Key and Treasure")
    }
    
    func goBackToPreviousView() {
        switch currentView {
        case .initial:
            // Não há view anterior para o estado inicial
            break
        case .startGame:
            currentView = .initial
        case .luzScanner:
            currentView = .startGame
        case .phase1Questions:
            currentView = .luzScanner
        case .maquiagemScanner:
            currentView = .phase1Questions
        case .phase2Questions:
            currentView = .maquiagemScanner
        case .phase3Intro:
            currentView = .phase2Questions
        case .luzScannerPhase3:
            currentView = .phase3Intro
        case .phase3Questions:
            currentView = .luzScannerPhase3
        case .gameComplete:
            currentView = .phase3Questions
        case .arContainerFinal:
            currentView = .arExperienceFinal
        case .arExperienceFinal:
            currentView = .gameComplete
        }
        print("🔙 Going back to previous view")
    }
    
    // MARK: - Phase Management
    func completePhase1() {
        phase1CorrectAnswers = 3
        currentPhase = .phase1Completed
        print("✅ Phase 1 completed successfully")
    }
    
    func completePhase2() {
        phase2CorrectAnswers = 3
        currentPhase = .phase2Completed
        print("✅ Phase 2 completed successfully")
    }
    
    func completePhase3() {
        phase3CorrectAnswers = 3
        currentPhase = .phase3Completed
        print("✅ Phase 3 completed successfully")
    }
    
    func resetGame() {
        currentView = .initial
        currentPhase = .initial
        phase1CorrectAnswers = 0
        phase2CorrectAnswers = 0
        phase3CorrectAnswers = 0
        isInstructionsVisible = false
        isScanInstructionsVisible = false
        isTrackingActive = false
        detectionCount = 0
        hasShownInstructions = false
        print("🔄 Game reset to initial state")
    }
    
    // MARK: - Private Methods
    private func showInstructions() {
        isInstructionsVisible = true
        hasShownInstructions = true
    }
    
    private func hideInstructions() {
        isInstructionsVisible = false
    }
    
    private func showScanInstructions() {
        isScanInstructionsVisible = true
    }
    
    private func hideScanInstructions() {
        isScanInstructionsVisible = false
    }
}

