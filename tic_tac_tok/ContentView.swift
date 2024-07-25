//
//  ContentView.swift
//  TicTacToeSwiftUI
//
//  Created by Tihomir RAdeff on 29.03.23.
//

import SwiftUI

struct ContentView: View {
    
    let boardSize = 3
    let robotPlayer = "O"
    let humanPlayer = "X"
    
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var isHumanTurn = true
    @State private var isGameOver = false
    @State private var winner = ""
    
    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .padding(.top, 50)
            
            Spacer()
            
            ForEach(0..<boardSize) { row in
                HStack {
                    ForEach(0..<boardSize) { col in
                        Button {
                            if !board[row][col].isEmpty || isGameOver {
                                return
                            }
                            
                            board[row][col] = humanPlayer
                            isHumanTurn.toggle()
                            
                            if checkWin(player: humanPlayer) {
                                winner = humanPlayer
                                isGameOver = true
                            } else if checkDraw() {
                                isGameOver = true
                            } else {
                                robotTurn()
                            }
                        } label: {
                            Text(board[row][col])
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .frame(width: 80, height: 80)
                                .background(.white)
                                .border(.black, width: 1)
                        }

                    }
                }
            }
            
            Spacer()
            
            if isGameOver {
                Text(winner.isEmpty ? "Draw" : "\(winner) wins!")
                    .font(.title)
                    .padding(.bottom, 50)
            }
        }
    }
    
    func checkWin(player: String) -> Bool {
        for i in 0..<boardSize {
            if board[i][0] == player && board[i][1] == player && board[i][2] == player {
                return true
            }
            
            if board[0][i] == player && board[1][i] == player && board[2][i] == player {
                return true
            }
        }
        
        if board[0][0] == player && board[1][1] == player && board[2][2] == player {
            return true
        }
        
        if board[0][2] == player && board[1][1] == player && board[2][0] == player {
            return true
        }
        
        return false
    }
    
    func checkDraw() -> Bool {
        for row in board {
            for cell in row {
                if cell.isEmpty {
                    return false
                }
            }
        }
        
        return true
    }
    
    //robot
    func minmax(depth: Int, isMaximizing: Bool) -> Int {
        if checkWin(player: robotPlayer) {
            return 10 - depth
        } else if checkWin(player: humanPlayer) {
            return depth - 10
        } else if checkDraw() {
            return 0
        }
        
        var bestScore = 0
        
        if isMaximizing {
            bestScore = Int.min
            
            for i in 0..<boardSize {
                for j in 0..<boardSize {
                    if board[i][j].isEmpty {
                        board[i][j] = robotPlayer
                        let score = minmax(depth: depth + 1, isMaximizing: false)
                        board[i][j] = ""
                        bestScore = max(score, bestScore)
                    }
                }
            }
        } else {
            bestScore = Int.max
            
            for i in 0..<boardSize {
                for j in 0..<boardSize {
                    if board[i][j].isEmpty {
                        board[i][j] = humanPlayer
                        let score = minmax(depth: depth + 1, isMaximizing: true)
                        board[i][j] = ""
                        bestScore = min(score, bestScore)
                    }
                }
            }
        }
        
        return bestScore
    }
    
    func robotTurn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var bestScore = Int.min
            var bestMove = (-1, -1)
            
            for i in 0..<boardSize {
                for j in 0..<boardSize {
                    if board[i][j].isEmpty {
                        board[i][j] = robotPlayer
                        let score = minmax(depth: 0, isMaximizing: false)
                        board[i][j] = ""
                        
                        if score > bestScore {
                            bestScore = score
                            bestMove = (i, j)
                        }
                    }
                }
            }
            
            board[bestMove.0][bestMove.1] = robotPlayer
            isHumanTurn.toggle()
            
            if checkWin(player: robotPlayer) {
                winner = robotPlayer
                isGameOver = true
            } else if checkDraw() {
                isGameOver = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
