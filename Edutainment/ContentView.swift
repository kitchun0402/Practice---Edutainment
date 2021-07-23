//
//  ContentView.swift
//  Edutainment
//
//  Created by kit chun on 22/7/2021.
//

import SwiftUI

struct Question {
    let text: String
    let answer: Int
}
let maxNumberOfQuestions = 25
struct ContentView: View {
    let maxNumberOfMultiplication = 12
    let questionRange = [5, 10, 20, maxNumberOfQuestions]
    @State private var selectedNumberOfQuestion = 0
    @State private var selectedMultiplication = 1
    @State private var isGameStarted = false
    @State private var currentQuestion = 0
    @State private var questions = [Question]()
    @State private var userAns = ""
    @State private var message = ""
    @State private var score = 0
    @State private var alertMessage = ""
    @State private var isGameFinished = false
    var body: some View {
        NavigationView{
            VStack() {
                if !isGameStarted {
                    buildSettingView()
                }
                if isGameStarted {
                    buildGameView()
                }
                Spacer()
            }.padding()
            .navigationBarTitle(Text("Edutainment"))
            .alert(isPresented: $isGameFinished) {
                Alert(title: Text("Thanks for your effort"), message: Text(alertMessage), dismissButton: .default(Text("Play again"), action: resetGame))
            }
        }
    }
    
    func buildGameView() -> some View {
        Group {
            VStack(alignment: .center, spacing: 50) {
                VStack {
                    Text("Question \(currentQuestion + 1) out of \(questions.count)").font(.footnote)
                    Text("What is \(questions[currentQuestion].text) ?").font(.title)
                }
                VStack{
                    TextField("Answer", text: $userAns).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad)
                        .frame(width: 200,alignment: .center)
                    Text(message).font(.footnote).foregroundColor(message == "Correct" ? .green : .red)
                }
                Button(action: {
                    compareAnswer()
                    userAns = ""
                    withAnimation(){
                        if currentQuestion == questions.count - 1 {
                            alertMessage = "Your score is \(score) out of \(questions.count)"
                            isGameFinished = true
                        } else {
                            currentQuestion += 1
                        }
                        
                    }
                }){
                    Image("rabbit" ).resizable().scaledToFit().frame(width: 50)
                    Text("Next").foregroundColor(.purple ).font(.title)
                }
            }.padding()
            
        }
    }
    func buildSettingView() -> some View {
        Group {
            VStack(alignment: .leading) {
                Text("Choose your multiplication table").font(.headline)
                Stepper(value: $selectedMultiplication, in: 1 ... maxNumberOfMultiplication) {
                    Text("Your choice is \(self.selectedMultiplication)")
                }
            }
            VStack(alignment: .leading) {
                Text("Choose the number of questions").font(.headline)
                Picker("Choose", selection: $selectedNumberOfQuestion) {
                    ForEach(0 ..< questionRange.count){
                        if maxNumberOfQuestions == self.questionRange[$0] {
                            Text("All")
                            
                        } else {
                            Text("\(self.questionRange[$0])")
                        }
                        
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Button(action: {
                // start game
                withAnimation() {
                    startGame()
                }
            }){
                Image(isGameStarted ? "rabbit" :"chick").resizable().scaledToFit().frame(width: 50)
                Text(isGameStarted ? "Reset" :"Start Game").foregroundColor(isGameStarted ? .purple : .orange).font(.title)
            }.padding()
            
        }
    }
    
    func startGame() {
        self.generateQuestion()
        self.isGameStarted = true
    }
    func resetGame() {
        self.isGameStarted = false
        self.message = ""
        self.userAns = ""
        self.currentQuestion = 0
    }
    func generateQuestion() {
        questions.removeAll()
        for n in 1 ... questionRange[selectedNumberOfQuestion] {
            let q = Question(text: "\(selectedMultiplication) x \(n)", answer: selectedMultiplication * n)
            questions.append(q)
        }
    }
    
    func compareAnswer() {
        let userAnsNum = Int(userAns) ?? 0
        let isCorrect = userAnsNum == questions[currentQuestion].answer
    
        if isCorrect {
            score += 1
            message = "Correct"
            return
        }
        message = "Incorrect"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
