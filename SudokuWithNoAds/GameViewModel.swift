//
//  GameViewModel.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//


import Foundation
import SwiftUI

struct Coordinate: Hashable {
    let row: Int
    let col: Int
}

@MainActor
class GameViewModel: ObservableObject {
    @Published var grid: [[Int]] = []
    @Published var solution: [[Int]] = []
    @Published var givenGrid: [[Bool]] = []
    @Published var selectedCell: (row: Int, col: Int)?
    @Published var incorrectCells: Set<Coordinate> = []
    @Published var highlightedNumber: Int?
    @Published var impossibleCells: Set<Coordinate> = []
    @Published var lives = 3
    @Published var time = 0
    @Published var isGameOver = false
    @Published var isGameWon = false
    @Published var difficulty: Difficulty
    @Published var currentScore = 0
    @Published var completedNumbers: Set<Int> = []
    var formattedTime: String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    @AppStorage("highScore") var highScore = 0
    @AppStorage("gamesPlayed") var gamesPlayed = 0
    @AppStorage("gamesWon") var gamesWon = 0

    private var timer: Timer?
    private let generator = SudokuGenerator()

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        startNewGame()
    }

    func startNewGame() {
        let (puzzle, solution) = generator.generatePuzzle(difficulty: difficulty)
        self.grid = puzzle
        self.solution = solution
        self.givenGrid = puzzle.map { row in row.map { $0 != 0 } }
        self.lives = 3
        self.time = 0
        self.isGameOver = false
        self.isGameWon = false
        self.selectedCell = nil
        self.incorrectCells = []
        self.highlightedNumber = nil
        self.impossibleCells = []
        self.currentScore = 0
        updateCompletedNumbers()
        gamesPlayed += 1
        startTimer()
    }

    func selectCell(row: Int, col: Int) {
        selectedCell = (row, col)
        
        let number = grid[row][col]
        if number != 0 {
            highlightedNumber = number
            updateImpossibleCells(for: number)
        } else {
            highlightedNumber = nil
            impossibleCells = []
        }
    }

    func enterNumber(_ number: Int) {
        guard let selectedCell = selectedCell else { return }
        let coordinate = Coordinate(row: selectedCell.row, col: selectedCell.col)
        
        if solution[selectedCell.row][selectedCell.col] == number {
            grid[selectedCell.row][selectedCell.col] = number
            incorrectCells.remove(coordinate)
            
            // Add points for correct guess
            currentScore += 10 * difficulty.scoreMultiplier
            checkForCompletionBonuses(row: selectedCell.row, col: selectedCell.col)

            if highlightedNumber != nil {
                highlightedNumber = number
                updateImpossibleCells(for: number)
            }
            updateCompletedNumbers()
            checkWinCondition()
        } else {
            lives -= 1
            incorrectCells.insert(coordinate)
            if lives == 0 {
                isGameOver = true
                stopTimer()
                calculateScore()
            }
        }
    }
    
    private func checkForCompletionBonuses(row: Int, col: Int) {
        // Check if row is complete
        if !grid[row].contains(0) {
            currentScore += 50 * difficulty.scoreMultiplier
        }
        
        // Check if column is complete
        var isColComplete = true
        for r in 0..<9 {
            if grid[r][col] == 0 {
                isColComplete = false
                break
            }
        }
        if isColComplete {
            currentScore += 50 * difficulty.scoreMultiplier
        }
        
        // Check if 3x3 box is complete
        let startRow = row - row % 3
        let startCol = col - col % 3
        var isBoxComplete = true
        for r in 0..<3 {
            for c in 0..<3 {
                if grid[startRow + r][startCol + c] == 0 {
                    isBoxComplete = false
                    break
                }
            }
            if !isBoxComplete { break }
        }
        if isBoxComplete {
            currentScore += 50 * difficulty.scoreMultiplier
        }
    }
    
    private func updateCompletedNumbers() {
        var counts = [Int: Int]()
        for row in grid {
            for cell in row {
                if cell != 0 {
                    counts[cell, default: 0] += 1
                }
            }
        }
        
        for (number, count) in counts {
            if count == 9 {
                completedNumbers.insert(number)
            }
        }
    }
    
    private func updateImpossibleCells(for number: Int) {
        impossibleCells = []
        for r in 0..<9 {
            for c in 0..<9 {
                if grid[r][c] == 0 && !isSafe(row: r, col: c, num: number) {
                    impossibleCells.insert(Coordinate(row: r, col: c))
                }
            }
        }
    }
    
    private func isSafe(row: Int, col: Int, num: Int) -> Bool {
        // Check row
        for c in 0..<9 {
            if grid[row][c] == num {
                return false
            }
        }
        // Check column
        for r in 0..<9 {
            if grid[r][col] == num {
                return false
            }
        }
        // Check 3x3 box
        let startRow = row - row % 3
        let startCol = col - col % 3
        for r in 0..<3 {
            for c in 0..<3 {
                if grid[r + startRow][c + startCol] == num {
                    return false
                }
            }
        }
        return true
    }
    
    private func checkWinCondition() {
        let isFull = grid.allSatisfy { row in !row.contains(0) }
        if isFull {
            isGameWon = true
            gamesWon += 1
            stopTimer()
            calculateScore()
        }
    }
    
    private func calculateScore() {
        if currentScore > highScore {
            highScore = currentScore
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.time += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
