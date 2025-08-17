//
//  StartGameViewModel.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import Combine

@MainActor
final class StartGameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isTrackingActive = false
    
    // Estados das views - Centralizado para todas as mudanças de tela
    @Published var currentView: StartGameViewState = .initial
    
    // Estados das fases
    @Published var currentPhase: StartGamePhase = .phase1
    @Published var phase1CorrectAnswers = 0
    @Published var phase2CorrectAnswers = 0
    @Published var phase3CorrectAnswers = 0
    
    // Timer da missão
    @Published var timeRemaining: TimeInterval = 600 // 10 minutos
    @Published var isTimerRunning: Bool = false
    @Published var isMissionFailed: Bool = false
    
    // MARK: - Private Properties
    private var hasShownInstructions = false
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init() {
        setupTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Timer Management
    private func setupTimer() {
        // Timer não inicia automaticamente, só quando a missão começa
    }
    
    func startMissionTimer() {
        timeRemaining = 600 // 10 minutos
        isTimerRunning = true
        isMissionFailed = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTimer()
            }
        }
        
        print("⏰ Timer da missão iniciado: 10 minutos restantes")
    }
    
    private func updateTimer() {
        guard timeRemaining > 0 else {
            missionFailed()
            return
        }
        
        timeRemaining -= 1
        
        // Atualizar a cada 10 segundos para performance
        if Int(timeRemaining) % 10 == 0 {
            print("⏰ Tempo restante: \(formatTime(timeRemaining))")
        }
    }
    
    func stopMissionTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        print("⏰ Timer da missão parado")
    }
    
    func penaltyTime() {
        timeRemaining = max(0, timeRemaining - 30)
        print("⏰ Penalidade de 30 segundos aplicada! Tempo restante: \(formatTime(timeRemaining))")
        
        if timeRemaining <= 0 {
            missionFailed()
        }
    }
    
    private func missionFailed() {
        isMissionFailed = true
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        currentView = .missionFailed
        print("💥 MISSÃO FALHOU! Tempo esgotado!")
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Public Methods
    func handleRocketDetection() {
        currentView = .missionStarted
        startMissionTimer() // Inicia o timer quando a missão começa
    }
    
    func handleStartScanning() {
        // Fechar o AR e abrir o scanner do sticker "luz"
        currentView = .luzScanner
        print("🚀 Closing AR and opening Luz Sticker Scanner")
    }
    
    func goBackToAR() {
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
        currentPhase = .phase3
        
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
        case .intro:
            currentView = .startGame
        case .missionStarted:
            currentView = .intro
        case .luzScanner:
            currentView = .missionStarted
        case .luzScannerSuccess:
            currentView = .luzScanner
        case .phase1Questions:
            currentView = .luzScannerSuccess
        case .maquiagemScanner:
            currentView = .phase1Questions
        case .maquiagemScannerSuccess:
            currentView = .maquiagemScanner
        case .phase2Questions:
            currentView = .maquiagemScannerSuccess
        case .phase3Intro:
            currentView = .phase2Questions
        case .luzScannerPhase3:
            currentView = .phase3Intro
        case .luzScannerPhase3Success:
            currentView = .luzScannerPhase3
        case .phase3Questions:
            currentView = .luzScannerPhase3Success
        case .gameComplete:
            currentView = .phase3Questions
        case .arContainerFinal:
            currentView = .arExperienceFinal
        case .arExperienceFinal:
            currentView = .gameComplete
        case .missionFailed:
            currentView = .initial
        }
        print("🔙 Going back to previous view")
    }
    
    // MARK: - Phase Management
    func completePhase1() {
        phase1CorrectAnswers = 3
        currentPhase = .phase2
        print("✅ Phase 1 completed successfully")
    }
    
    func completePhase2() {
        phase2CorrectAnswers = 3
        currentPhase = .phase3
        print("✅ Phase 2 completed successfully")
    }
    
    func completePhase3() {
        phase3CorrectAnswers = 3
        currentPhase = .completed
        print("✅ Phase 3 completed successfully")
    }
    
    func resetGame() {
        currentView = .initial
        currentPhase = .phase1
        phase1CorrectAnswers = 0
        phase2CorrectAnswers = 0
        phase3CorrectAnswers = 0
        isTrackingActive = false
        hasShownInstructions = false
        stopMissionTimer()
        timeRemaining = 600
        isMissionFailed = false
        print("🔄 Game reset to initial state")
    }
}

