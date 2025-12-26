//
//  StartView.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//


import SwiftUI

struct StartView: View {
    @State private var selectedDifficulty: Difficulty?
    @AppStorage("highScore") var highScore = 0
    @AppStorage("gamesPlayed") var gamesPlayed = 0
    @AppStorage("gamesWon") var gamesWon = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sudoku")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack {
                    Text("High Score: \(highScore)")
                    Text("Games Played: \(gamesPlayed)")
                    Text("Games Won: \(gamesWon)")
                }
                .font(.title3)
                .padding()

                ForEach(Difficulty.allCases) { difficulty in
                    Button {
                        selectedDifficulty = difficulty
                    } label: {
                        Text(difficulty.rawValue)
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationDestination(item: $selectedDifficulty) { difficulty in
                GameView(difficulty: difficulty)
            }
        }
    }
}
