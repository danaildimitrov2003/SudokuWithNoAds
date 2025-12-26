//
//  SudokuGenerator.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//


import Foundation

class SudokuGenerator {
    private let size = 9
    private let boxSize = 3
    private var grid: [[Int]] = []

    init() {
        grid = Array(repeating: Array(repeating: 0, count: size), count: size)
    }

    func generatePuzzle(difficulty: Difficulty) -> (puzzle: [[Int]], solution: [[Int]]) {
        grid = Array(repeating: Array(repeating: 0, count: size), count: size)
        let _ = fillGrid()
        let solution = grid
        var puzzle = grid

        var cells = [(Int, Int)]()
        for r in 0..<size {
            for c in 0..<size {
                cells.append((r, c))
            }
        }
        cells.shuffle()

        var removed = 0

        for (r, c) in cells {
            if removed >= difficulty.cellsToRemove { break }

            let backup = puzzle[r][c]
            puzzle[r][c] = 0

            var copy = puzzle
            let solutions = countSolutions(&copy, limit: 2)

            if solutions == 1 {
                removed += 1
            } else {
                puzzle[r][c] = backup
            }
        }

        return (puzzle, solution)
    }

    // MARK: - Grid filling (full solution)

    private func fillGrid() -> Bool {
        for r in 0..<size {
            for c in 0..<size {
                if grid[r][c] == 0 {
                    for num in (1...9).shuffled() {
                        if isSafe(grid, r, c, num) {
                            grid[r][c] = num
                            if fillGrid() { return true }
                            grid[r][c] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }

    // MARK: - Solution counter (uniqueness check)

    private func countSolutions(_ grid: inout [[Int]], limit: Int) -> Int {
        for r in 0..<size {
            for c in 0..<size {
                if grid[r][c] == 0 {
                    var count = 0
                    for num in 1...9 {
                        if isSafe(grid, r, c, num) {
                            grid[r][c] = num
                            count += countSolutions(&grid, limit: limit)
                            if count >= limit {
                                grid[r][c] = 0
                                return count
                            }
                            grid[r][c] = 0
                        }
                    }
                    return count
                }
            }
        }
        return 1
    }

    // MARK: - Safety check

    private func isSafe(_ grid: [[Int]], _ row: Int, _ col: Int, _ num: Int) -> Bool {
        for i in 0..<size {
            if grid[row][i] == num || grid[i][col] == num {
                return false
            }
        }

        let startRow = row - row % boxSize
        let startCol = col - col % boxSize

        for r in 0..<boxSize {
            for c in 0..<boxSize {
                if grid[startRow + r][startCol + c] == num {
                    return false
                }
            }
        }
        return true
    }
}
