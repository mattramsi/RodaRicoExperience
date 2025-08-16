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
    @Published var showInstructions = true
    @Published var showCode = false
    @Published var finalCode = ""
    
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
    
    func openBau() {
        isBauOpen = true
        isCardVisible = false
        showInstructions = false
        generateFinalCode()
        print("Baú aberto com sucesso! Código gerado: \(finalCode)")
    }
    
    private func generateFinalCode() {
        // Gerar código de 6 dígitos aleatório
        let digits = (0...9).map { String($0) }
        finalCode = (0..<6).map { _ in digits.randomElement()! }.joined()
        showCode = true
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
            // Instruções iniciais
            if viewModel.showInstructions {
                instructionsView
                    .transition(.opacity.combined(with: .scale))
            }
            
            // Código final quando o baú abrir
            if viewModel.showCode {
                codeView
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.showCode)
            }
            
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
            
            if viewModel.isBauOpen {
                celebrationEffects
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.showCode)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isBauOpen)
    }

    func checkCollision() {
        if abs(self.xPosition1 - self.xPosition2) < 100 && abs(self.yPosition1 - self.yPosition2) < 100 {
            if !collision {
                collision = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.viewModel.openBau()
                }
            }
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
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.yellow)
            .frame(width: 60, height: 60)
            .overlay(
                Text("🔑")
                    .font(.title)
                    .foregroundColor(.black)
            )
    }
    
    private var instructionsView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("🎯 Experiência AR Final")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Arraste a chave amarela até o baú para abri-lo")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Quando o baú abrir, você receberá um código de 6 dígitos como recompensa!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(30)
            .background(Color.black.opacity(0.7))
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    private var codeView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("🎊 Parabéns!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .scaleEffect(viewModel.showCode ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: viewModel.showCode)
                
                Text("Você completou a jornada RodaRico!")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .scaleEffect(viewModel.showCode ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: viewModel.showCode)
                
                Text("Seu código de recompensa é:")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .scaleEffect(viewModel.showCode ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: viewModel.showCode)
                
                Text(viewModel.finalCode)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(.orange)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.orange, lineWidth: 3)
                            )
                    )
                    .scaleEffect(viewModel.showCode ? 1.0 : 0.5)
                    .opacity(viewModel.showCode ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.8), value: viewModel.showCode)
                
                Text("Guarde este código! É sua recompensa final!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .scaleEffect(viewModel.showCode ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: viewModel.showCode)
            }
            .padding(30)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    private var celebrationEffects: some View {
        ZStack {
            // Partículas de celebração
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 8)
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .scaleEffect(viewModel.isBauOpen ? 1.0 : 0.0)
                    .opacity(viewModel.isBauOpen ? 0.8 : 0.0)
                    .animation(
                        .easeOut(duration: 2.0)
                        .delay(Double(index) * 0.1),
                        value: viewModel.isBauOpen
                    )
            }
            
            // Efeito de explosão no centro do baú
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.orange, .yellow, .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .position(x: xPosition1, y: yPosition1)
                .scaleEffect(viewModel.isBauOpen ? 2.0 : 0.0)
                .opacity(viewModel.isBauOpen ? 0.0 : 0.8)
                .animation(.easeOut(duration: 1.0), value: viewModel.isBauOpen)
        }
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
