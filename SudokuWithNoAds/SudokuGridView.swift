//
//  SudokuGridView.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//

import SwiftUI

struct SudokuGridView: View {
    @Binding var grid: [[Int]]
    let given: [[Bool]]
    @Binding var selectedCell: (row: Int, col: Int)?
    let incorrectCells: Set<Coordinate>
    let highlightedNumber: Int?
    let impossibleCells: Set<Coordinate>
    let onSelect: (Int, Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9, id: \.self) { col in
                        CellView(
                            number: grid[row][col],
                            isGiven: given[row][col],
                            isSelected: selectedCell?.row == row && selectedCell?.col == col,
                            isIncorrect: incorrectCells.contains(Coordinate(row: row, col: col)),
                            isHighlighted: grid[row][col] != 0 && grid[row][col] == highlightedNumber,
                            isImpossible: grid[row][col] == 0 && impossibleCells.contains(Coordinate(row: row, col: col))
                        )
                        .onTapGesture {
                            onSelect(row, col)
                        }
                        .border(Color.black, width: 0.5)
                    }
                }
            }
        }
        .border(Color.black, width: 2)
    }
}
