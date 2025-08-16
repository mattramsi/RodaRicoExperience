//
//  QuestionsPhase3View.swift
//  RodaRicoExperience
//
//  Created by Matheus Silva on 12/08/25.
//

import SwiftUI

struct QuestionsPhase3View: View {
    @ObservedObject var viewModel: StartGameViewModel
    @State private var currentQuestionIndex = 0
    @State private var correctAnswers = 0
    @State private var showResult = false
    
    private let questions = [
        Question(
            text: "Qual foi o tema principal da sua jornada RodaRico?",
            options: ["Tecnologia", "Transformação e beleza", "Esporte", "Música"],
            correctAnswer: 1
        ),
        Question(
            text: "Quantas fases você completou até agora?",
            options: ["1", "2", "3", "4"],
            correctAnswer: 2
        ),
        Question(
            text: "O que representa a luz na sua jornada?",
            options: ["O fim da experiência", "O início de uma transformação", "Uma pausa", "Um erro"],
            correctAnswer: 1
        )
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Progresso Final")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(correctAnswers)/3")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                
                ProgressView(value: Double(correctAnswers), total: 3.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            // Question Content
            VStack(spacing: 24) {
                Text("Pergunta Final \(currentQuestionIndex + 1) de \(questions.count)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text(questions[currentQuestionIndex].text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Answer Options
                VStack(spacing: 12) {
                    ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                        Button(action: {
                            selectAnswer(index)
                        }) {
                            HStack {
                                Text(questions[currentQuestionIndex].options[index])
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Voltar") {
                    viewModel.goBackToPreviousView()
                }
                .foregroundColor(.red)
            }
        }
        .alert("Resultado Final", isPresented: $showResult) {
            Button("Continuar") {
                if correctAnswers == 3 {
                    print("🎉 Todas as perguntas da Fase 3 foram respondidas com sucesso! Jornada completa!")
                    viewModel.completePhase3()
                    viewModel.navigateToARContainerFinal()
                } else {
                    currentQuestionIndex = 0
                    correctAnswers = 0
                }
            }
        } message: {
            if correctAnswers == 3 {
                Text("🎊 Parabéns! Você completou toda a experiência RodaRico! Acesse sua recompensa AR especial!")
            } else {
                Text("Você acertou \(correctAnswers) de 3 perguntas. Tente novamente para completar sua jornada!")
            }
        }
    }
    
    private func selectAnswer(_ selectedIndex: Int) {
        let question = questions[currentQuestionIndex]
        
        if selectedIndex == question.correctAnswer {
            correctAnswers += 1
            print("✅ Pergunta final \(currentQuestionIndex + 1) da Fase 3 respondida corretamente!")
        } else {
            print("❌ Pergunta final \(currentQuestionIndex + 1) da Fase 3 respondida incorretamente. Resposta correta: \(question.options[question.correctAnswer])")
        }
        
        // Avançar para próxima pergunta ou mostrar resultado
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showResult = true
        }
    }
}

#Preview {
    NavigationView {
        QuestionsPhase3View(viewModel: StartGameViewModel())
    }
}
