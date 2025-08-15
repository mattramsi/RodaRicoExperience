//
//  ARContainerView.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI
import ARKit
import RealityKit

// MARK: - Main View
struct ARExperienceView: View {
    @StateObject private var viewModel = ARExperienceViewModel()
    
    var body: some View {
        ZStack {
            // AR Container
            ARExperienceContainerView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // UI Overlay
            ARExperienceOverlayView(viewModel: viewModel)
            
            // Card Modal
            if viewModel.isCardVisible {
                ARCardModalView(
                    isVisible: $viewModel.isCardVisible,
                    onCardTapped: viewModel.handleCardTap
                )
            }
        }
        .navigationTitle("AR Experience")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - View Model
@MainActor
final class ARExperienceViewModel: ObservableObject {
    @Published var isCardVisible = false
    @Published var isBauOpen = false
    @Published var isDraggingKey = false
    @Published var keyPosition: CGPoint = .zero
    @Published var isKeyTouchingBau = false
    
    func handleCardTap() {
        print("Cartão clicado!")
        isCardVisible = false
    }
    
    func handleBauTap() {
        if !isBauOpen {
            isCardVisible = true
        }
    }
    
    func handleKeyDrag(translation: CGSize) {
        // Update key position based on drag
        keyPosition = CGPoint(
            x: keyPosition.x + translation.width,
            y: keyPosition.y + translation.height
        )
        print("Key moved to: \(keyPosition)")
        checkKeyBauCollision()
    }
    
    func handleKeyDragEnd() {
        isDraggingKey = false
        if isKeyTouchingBau {
            openBau()
        }
    }
    
    func checkKeyBauCollision() {
        // Get screen dimensions
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Bau is at center of screen
        let bauCenterX = screenWidth / 2
        let bauCenterY = screenHeight / 2
        
        // Key position (relative to screen)
        let keyCenterX = keyPosition.x + 30 // 30 is half of key width (60/2)
        let keyCenterY = keyPosition.y + 30 // 30 is half of key height (60/2)
        
        let distance = sqrt(
            pow(keyCenterX - bauCenterX, 2) + 
            pow(keyCenterY - bauCenterY, 2)
        )
        
        let isTouching = distance < 90 // 60 (key radius) + 60 (bau radius) / 2
        
        if isTouching && !isKeyTouchingBau {
            isKeyTouchingBau = true
            print("Chave encostou no baú! Distância: \(distance)")
        } else if !isTouching && isKeyTouchingBau {
            isKeyTouchingBau = false
            print("Chave saiu do baú")
        }
    }
    
    private func openBau() {
        isBauOpen = true
        isCardVisible = false
        print("Baú aberto com sucesso!")
    }
}

// MARK: - AR Container View
struct ARExperienceContainerView: UIViewRepresentable {
    let viewModel: ARExperienceViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        let coordinator = context.coordinator
        
        configureARSession(for: arView)
        coordinator.setupARView(arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update view if needed
    }
    
    func makeCoordinator() -> ARExperienceCoordinator {
        ARExperienceCoordinator(viewModel: viewModel)
    }
    
    private func configureARSession(for arView: ARView) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
    }
}

// MARK: - AR Coordinator
final class ARExperienceCoordinator: NSObject {
    private let viewModel: ARExperienceViewModel
    private weak var arView: ARView?
    
    init(viewModel: ARExperienceViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func setupARView(_ arView: ARView) {
        self.arView = arView
        // Additional AR setup can be added here
    }
}

// MARK: - UI Overlay View
struct ARExperienceOverlayView: View {
    @ObservedObject var viewModel: ARExperienceViewModel
    
    @State var xPosition1: CGFloat = 200
    @State var yPosition1: CGFloat = 300

    @State var xPosition2: CGFloat = 200
    @State var yPosition2: CGFloat = 600

    @State var collision = false
    
    var body: some View {
        ZStack {
            bauView
            .position(x: xPosition1, y: yPosition1)
            
            VStack {
                Spacer()
                keyView
                .position(x: xPosition2, y: yPosition2)
                                 .gesture(
                     DragGesture()
                         .onChanged { value in
                             xPosition2 = value.location.x
                             yPosition2 = value.location.y
                             checkCollision()
                         }
                 )
            }
        }
    }

    func checkCollision() {
        if abs(self.xPosition1 - self.xPosition2) < 100 && abs(self.yPosition1 - self.yPosition2) < 100 {
            collision = true
        } else {
            collision = false
        }
    }
    
    private var bauView: some View {
        Button(action: {
//            viewModel.handleBauTap()
        }) {
            Image(collision ? "bau_aberto" : "bau_fechado")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .scaleEffect(viewModel.isBauOpen ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: viewModel.isBauOpen)
        }
        .disabled(viewModel.isBauOpen)
    }
    
    private var keyView: some View {
        // Simple key view that will definitely be visible
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.yellow)
            .frame(width: 60, height: 60)
            .overlay(
                Text("🔑")
                    .font(.title)
                    .foregroundColor(.black)
            )
    }
}

// MARK: - Control Button Component (Removed - No longer used)

// MARK: - Card Modal View
struct ARCardModalView: View {
    @Binding var isVisible: Bool
    let onCardTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            cardView
                .onTapGesture(perform: onCardTapped)
            
            Spacer()
        }
        .transition(.scale.combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: isVisible)
    }
    
    private var cardView: some View {
        Image(systemName: "creditcard.fill")
            .font(.system(size: 100))
            .foregroundColor(.blue)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ARExperienceView()
    }
}
