//
//  NumberPadView.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//

import SwiftUI

struct NumberPadView: View {
    let completedNumbers: Set<Int>
    let onNumberTapped: (Int) -> Void

    var body: some View {
        HStack {
            ForEach(1...9, id: \.self) { number in
                Button(action: { onNumberTapped(number) }) {
                    Text("\(number)")
                        .font(.largeTitle)
                        .frame(width: 35, height: 35)
                }
                .opacity(completedNumbers.contains(number) ? 0 : 1)
                .disabled(completedNumbers.contains(number))
            }
        }
    }
}
