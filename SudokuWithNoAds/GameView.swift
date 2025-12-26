//
//  GameView.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//


import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    init(difficulty: Difficulty) {
        _viewModel = StateObject(wrappedValue: GameViewModel(difficulty: difficulty))
    }

    var body: some View {
        VStack {
            // Header
            VStack {
                HStack {
                    Text("Lives: \(viewModel.lives)")
                    Spacer()
                    Text("Time: \(viewModel.time)")
                }
                HStack {
                    Text("Score: \(viewModel.currentScore)")
                    Spacer()
                    Text("High Score: \(viewModel.highScore)")
                }
            }

            SudokuGridView(
                grid: $viewModel.grid,
                given: viewModel.givenGrid,
                selectedCell: $viewModel.selectedCell,
                incorrectCells: viewModel.incorrectCells,
                highlightedNumber: viewModel.highlightedNumber,
                impossibleCells: viewModel.impossibleCells,
                onSelect: viewModel.selectCell
            )
            .padding(.vertical)

            Spacer()
            NumberPadView(
                completedNumbers: viewModel.completedNumbers,
                onNumberTapped: viewModel.enterNumber
            )
            .padding(.bottom)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .alert("Game Over", isPresented: $viewModel.isGameOver) {
            Button("New Game", action: viewModel.startNewGame)
            Button("Main Menu") { dismiss() }
        } message: {
            Text("You've run out of lives!")
        }
        .alert("You Won!", isPresented: $viewModel.isGameWon) {
            Button("New Game", action: viewModel.startNewGame)
            Button("Main Menu") { dismiss() }
        } message: {
            Text("Congratulations! You solved the puzzle in \(viewModel.time) seconds.")
        }
    }
}
