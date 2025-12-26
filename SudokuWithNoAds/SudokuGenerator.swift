//
//  SudokuGenerator.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//


import Foundation

class SudokuGenerator {
    private var grid: [[Int]]
    private let size = 9
    private let boxSize = 3

    init() {
        self.grid = Array(repeating: Array(repeating: 0, count: size), count: size)
    }

    func generatePuzzle(difficulty: Difficulty) -> (puzzle: [[Int]], solution: [[Int]]) {
        grid = Array(repeating: Array(repeating: 0, count: size), count: size)
        fillGrid()
        let solution = grid
        var puzzle = grid
        
        var cells = [(Int, Int)]()
        for r in 0..<size {
            for c in 0..<size {
                cells.append((r, c))
            }
        }
        cells.shuffle()
        
        for i in 0..<difficulty.cellsToRemove {
            let cell = cells[i]
            puzzle[cell.0][cell.1] = 0
        }
        
        return (puzzle, solution)
    }

    private func fillGrid() -> Bool {
        for r in 0..<size {
            for c in 0..<size {
                if grid[r][c] == 0 {
                    let numbers = (1...9).shuffled()
                    for number in numbers {
                        if isSafe(row: r, col: c, num: number) {
                            grid[r][c] = number
                            if fillGrid() {
                                return true
                            }
                            grid[r][c] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }

    private func isSafe(row: Int, col: Int, num: Int) -> Bool {
        // Check row
        for c in 0..<size {
            if grid[row][c] == num {
                return false
            }
        }
        // Check column
        for r in 0..<size {
            if grid[r][col] == num {
                return false
            }
        }
        // Check 3x3 box
        let startRow = row - row % boxSize
        let startCol = col - col % boxSize
        for r in 0..<boxSize {
            for c in 0..<boxSize {
                if grid[r + startRow][c + startCol] == num {
                    return false
                }
            }
        }
        return true
    }
}
