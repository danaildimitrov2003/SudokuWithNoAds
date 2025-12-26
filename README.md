# SudokuWithNoAds

A simple and clean Sudoku game for iOS built with SwiftUI. This project focuses on providing a straightforward Sudoku experience without advertisements. Was bored on my PTO and tired of ads on other sudoku apps so decided to create one without

## Features

- **Multiple Difficulty Levels**: Choose from a range of difficulties, from "Easy" to the challenging "You cannot do this".
- **Interactive Grid**: Tap to select cells and input numbers.
- **Input Validation**: Incorrect numbers are immediately flagged.
- **Number Highlighting**: Selecting a cell with a number highlights all instances of that number on the grid.
- **Game Statistics**: Tracks lives, time, and your current score.
- **Persistent Stats**: Saves your high score, total games played, and games won across sessions.
- **Clean UI**: A minimalist interface built entirely in SwiftUI.

## How to Build and Run

1.  Clone the repository.
2.  Open `SudokuWithNoAds.xcodeproj` in Xcode.
3.  Select an iOS simulator or connect a physical device.
4.  Press the "Run" button (▶) to build and launch the application.

## Project Structure

-   `SudokuWithNoAdsApp.swift`: The main entry point for the SwiftUI application.
-   `ContentView.swift`: The root view that hosts the `StartView`.
-   `StartView.swift`: The initial screen where the user can select a difficulty and view their stats.
-   `GameView.swift`: The main view for the game, containing the grid, stats display, and number pad.
-   `GameViewModel.swift`: An `ObservableObject` that contains all the game logic, state management, and data.
-   `SudokuGenerator.swift`: A class responsible for generating new Sudoku puzzles and their solutions.
-   `Difficulty.swift`: An enum defining the different game difficulties and their associated properties (e.g., cells to remove, score multiplier).
-   **Component Views**:
    -   `SudokuGridView.swift`: Renders the 9x9 Sudoku grid.
    -   `CellView.swift`: Represents a single cell within the grid.
    -   `NumberPadView.swift`: The view for number input.
