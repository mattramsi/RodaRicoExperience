//
//  StartGameViewState.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import Foundation

enum StartGameViewState {
    case initial
    case intro
    case startGame
    case missionStarted
    case luzScanner
    case luzScannerSuccess
    case phase1Questions
    case maquiagemScanner
    case maquiagemScannerSuccess
    case phase2Questions
    case phase3Intro
    case luzScannerPhase3
    case luzScannerPhase3Success
    case phase3Questions
    case gameComplete
    case arContainerFinal
    case arExperienceFinal
    case missionFailed
}

enum StartGamePhase {
    case phase1
    case phase2
    case phase3
    case completed
}

struct StartGameViewStateData {
    var currentView: StartGameViewState = .initial
    var currentPhase: StartGamePhase = .phase1
    var missionTimer: TimeInterval = 600 // 10 minutos em segundos
    var isTimerRunning: Bool = false
    var timeRemaining: TimeInterval = 600
    var isMissionFailed: Bool = false
}
