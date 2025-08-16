//
//  StartGameProtocols.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import Foundation
import ARKit

// MARK: - Rocket Detection Protocol
protocol RocketDetectionProtocol {
    func handleRocketDetection()
    func updateTrackingStatus(_ isActive: Bool)
}

// MARK: - AR Session Management Protocol
protocol ARSessionManagementProtocol {
    func setupARSession()
    func configureImageTracking()
    func handleImageAnchor(_ anchor: ARImageAnchor)
}

// MARK: - UI State Management Protocol
protocol UIStateManagementProtocol {
    var isInstructionsVisible: Bool { get set }
    var isTrackingActive: Bool { get set }
    var detectionCount: Int { get set }
    
    func showInstructions()
    func hideInstructions()
    func incrementDetectionCount()
}

