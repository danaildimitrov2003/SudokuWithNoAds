//
//  CellView.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//

import SwiftUI

struct CellView: View {
    let number: Int
    let isGiven: Bool
    let isSelected: Bool
    let isIncorrect: Bool
    let isHighlighted: Bool
    let isImpossible: Bool

    var body: some View {
        Text(number == 0 ? " " : "\(number)")
            .font(.title)
            .fontWeight(isGiven ? .bold : .regular)
            .frame(width: 40, height: 40)
            .background(
                Group {
                    if isIncorrect {
                        Color.red.opacity(0.5)
                    } else if isHighlighted {
                        Color.blue.opacity(0.3)
                    } else if isSelected {
                        Color.yellow.opacity(0.5)
                    } else if isImpossible {
                        Color.gray.opacity(0.3)
                    } else {
                        Color.clear
                    }
                }
            )
            .foregroundColor(isGiven ? .black : .blue)
    }
}
