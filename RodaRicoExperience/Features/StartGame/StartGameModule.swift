//
//  StartGameModule.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//
//  Este arquivo serve como ponto de entrada principal para o módulo StartGame
//  e ajuda a resolver problemas de compilação

import SwiftUI

// MARK: - Module Public Interface
public struct StartGameModule {
    public static let version = "1.0.0"
    
    public static func initialize() {
        print("🚀 StartGame Module initialized - Version \(version)")
        print("📁 Organized structure loaded successfully")
    }
}

// MARK: - Convenience Extensions
extension StartGameViewState {
    public var displayName: String {
        switch self {
        case .initial: return "Initial"
        case .intro: return "Intro"
        case .startGame: return "AR View"
        case .missionStarted: return "Mission Started"
        case .luzScanner: return "Luz Scanner"
        case .luzScannerSuccess: return "Luz Scanner Success"
        case .phase1Questions: return "Phase 1 Questions"
        case .maquiagemScanner: return "Maquiagem Scanner"
        case .maquiagemScannerSuccess: return "Maquiagem Scanner Success"
        case .phase2Questions: return "Phase 2 Questions"
        case .phase3Intro: return "Phase 3 Intro"
        case .luzScannerPhase3: return "Luz Scanner Phase 3"
        case .luzScannerPhase3Success: return "Luz Scanner Succes"
        case .phase3Questions: return "Phase 3 Questions"
        case .gameComplete: return "Game Complete"
        case .arContainerFinal: return "AR Container Final"
        case .arExperienceFinal: return "AR Experience Final"
        case .missionFailed: return "Mission Failed"
        }
    }
}

extension GamePhase {
    public var displayName: String {
        switch self {
        case .initial: return "Initial"
        case .phase1Completed: return "Phase 1 Completed"
        case .phase2Completed: return "Phase 2 Completed"
        case .phase3Intro: return "Phase 3 Intro"
        case .phase3Completed: return "Phase 3 Completed"
        case .gameCompleted: return "Game Completed"
        }
    }
}
