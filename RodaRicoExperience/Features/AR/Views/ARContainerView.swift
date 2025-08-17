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
struct TreasureHuntARView: View {
    @StateObject private var viewModel = TreasureHuntARViewModel()
    @EnvironmentObject private var startGameviewModel: StartGameViewModel
    
    var body: some View {
        ZStack {
            // AR Container - só mostra quando o jogo não terminou
            if !viewModel.showCode {
                TreasureHuntARContainerView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(0)
                
                TreasureHuntAROverlayView(viewModel: viewModel)
                
                VStack {
                    VStack(spacing: 16) {
                        Text("🎯 Caça ao Tesouro AR")
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
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
            
            // Código final quando o baú abrir - cobre toda a tela
            if viewModel.showCode {
                TreasureHuntFinalRewardView(
                    finalCode: viewModel.finalCode,
                    onPlayAgain: {
                        startGameviewModel.resetGame()
                        viewModel.resetGame()
                    }
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.showCode)
                .zIndex(1) // Garante que fique acima de tudo
            }
        }
        .navigationTitle("Caça ao Tesouro AR")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - View Model
@MainActor
final class TreasureHuntARViewModel: ObservableObject {
    @Published var isCardVisible = false
    @Published var isBauOpen = false
    @Published var isDraggingKey = false
    @Published var keyPosition: CGPoint = .zero
    @Published var isKeyTouchingBau = false
    @Published var showInstructions = true
    @Published var showCode = false
    @Published var finalCode = ""
    @Published var collision = false

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
    
    func resetGame() {
        isBauOpen = false
        isCardVisible = false
        showInstructions = true
        isKeyTouchingBau = false
        keyPosition = .zero
        showCode = false
        finalCode = ""
        collision = false
    }
    
    // Método para resetar posições dos elementos
    func resetPositions() -> (CGPoint, CGPoint) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let bauPosition = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        let keyPosition = CGPoint(x: screenWidth / 2, y: screenHeight * 0.8)
        
        return (bauPosition, keyPosition)
    }
}

// MARK: - AR Container View
struct TreasureHuntARContainerView: UIViewRepresentable {
    let viewModel: TreasureHuntARViewModel
    
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
    
    func makeCoordinator() -> TreasureHuntARCoordinator {
        TreasureHuntARCoordinator(viewModel: viewModel)
    }
    
    private func configureARSession(for arView: ARView) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
    }
}

// MARK: - AR Coordinator
final class TreasureHuntARCoordinator: NSObject {
    private let viewModel: TreasureHuntARViewModel
    private weak var arView: ARView?
    
    init(viewModel: TreasureHuntARViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func setupARView(_ arView: ARView) {
        self.arView = arView
        // Additional AR setup can be added here
    }
}

// MARK: - UI Overlay View
struct TreasureHuntAROverlayView: View {
    @ObservedObject var viewModel: TreasureHuntARViewModel
    
    // Posições variáveis para a chave e baú
    @State var keyX: CGFloat = 0
    @State var keyY: CGFloat = 0
    @State var bauX: CGFloat = 0
    @State var bauY: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            bauView
            .position(x: bauX, y: bauY)
            .zIndex(5)
            .onAppear {
                // Posicionar o baú no centro da tela
                bauX = UIScreen.main.bounds.width / 2
                bauY = UIScreen.main.bounds.height / 2
            }
            
            VStack {
                Spacer()
                keyView
                .position(x: keyX, y: keyY)
                .zIndex(5)
                .onAppear {
                    // Posicionar a chave na parte inferior central
                    keyX = UIScreen.main.bounds.width / 2
                    keyY = UIScreen.main.bounds.height * 0.8
                }
                .onChange(of: viewModel.showCode) { _, newValue in
                    if !newValue {
                        // Resetar posições quando o jogo for resetado
                        keyX = UIScreen.main.bounds.width / 2
                        keyY = UIScreen.main.bounds.height * 0.8
                        bauX = UIScreen.main.bounds.width / 2
                        bauY = UIScreen.main.bounds.height / 2
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Atualizar posição da chave conforme o arrasto
                            keyX = value.location.x
                            keyY = value.location.y
                            
                            // Verificar colisão
                            checkCollision(
                                keyPosition: CGPoint(x: keyX, y: keyY),
                                bauPosition: CGPoint(x: bauX, y: bauY)
                            )
                        }
                )
            }
            
            if viewModel.isBauOpen {
                celebrationEffects
                    .zIndex(8)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .animation(.easeInOut(duration: 0.5), value: viewModel.showCode)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isBauOpen)
    }

    func checkCollision(keyPosition: CGPoint, bauPosition: CGPoint) {
        let distance = sqrt(
            pow(keyPosition.x - bauPosition.x, 2) + 
            pow(keyPosition.y - bauPosition.y, 2)
        )
        
        let isTouching = distance < 100 // Raio de colisão
        
        if isTouching && !viewModel.collision {
            viewModel.collision = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.openBau()
            }
        } else if !isTouching && viewModel.collision {
            viewModel.collision = false
        }
    }
    
    private var bauView: some View {
        Button(action: {
//            viewModel.handleBauTap()
        }) {
            Image(viewModel.collision ? "bau_aberto" : "bau_fechado")
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
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .scaleEffect(viewModel.isBauOpen ? 2.0 : 0.0)
                .opacity(viewModel.isBauOpen ? 0.0 : 0.8)
                .animation(.easeOut(duration: 1.0), value: viewModel.isBauOpen)
        }
    }
}

// MARK: - Final Reward View
struct TreasureHuntFinalRewardView: View {
    let finalCode: String
    let onPlayAgain: () -> Void
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Espaçamento superior para evitar corte
                    Color.clear
                        .frame(height: 50)
                    
                    VStack(spacing: 25) {
                    Text("🎊 Parabéns!")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: true)
                    
                    Text("Você completou a jornada RodaRico!")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: true)
                    
                    Text("Seu código de recompensa é:")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: true)
                    
                    Text(finalCode)
                        .font(.system(size: 56, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.orange, lineWidth: 4)
                                )
                        )
                        .scaleEffect(1.0)
                        .opacity(1.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.8), value: true)
                    
                    Text("Guarde este código! É sua recompensa final!")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: true)
                    
                    // Botão Jogar Novamente
                    Button(action: onPlayAgain) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                            Text("Jogar Novamente")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.blue)
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                    }
                    .scaleEffect(1.0)
                    .opacity(1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.2), value: true)
                    .padding(.top, 20)
                }
                .padding(40)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.8))
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 30)
                
                Color.clear
                    .frame(height: 50)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        TreasureHuntARView()
    }
}
