//
//  Game.swift
//  TicTacToe
//
//  Created by Everton Baima on 11/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import Foundation

public class Game {
    // Status:
    // Ganhou [X, O], Empatou [E], Inacabado [I]
    static func verificarStatusDeJogo(_ jogadas:[Jogada]) -> String {
        // Menos de 5 jogadas == Jogo Inacabado
        if(jogadas.count < 5) {
            return "I"
        }
        
        // Ordenando jogadas pela data da mais antiga para a mais nova
        var jogadasOrdenadas = jogadas.sorted(by: { $0.data.compare($1.data) == .orderedAscending })
        
        // Criando matriz do jogo da velha com valores iniciais
        var tttMatrix: [String] = ["", "", "", "", "", "", "", "", ""]
        
        // Preenchendo matriz do jogo com as jogadas passadas
        for k in jogadasOrdenadas.indices {
            // Mapeando tupla em array unidimensional
            var posicao = -1
            
            switch(jogadasOrdenadas[k].jogada) {
                case (0, 0):
                    posicao = 0
                case (0, 1):
                    posicao = 1
                case (0, 2):
                    posicao = 2
                case (1, 0):
                    posicao = 3
                case (1, 1):
                    posicao = 4
                case (1, 2):
                    posicao = 5
                case (2, 0):
                    posicao = 6
                case (2, 1):
                    posicao = 7
                case (2, 2):
                    posicao = 8
                default:
                    posicao = -1
            }
            
            if(k % 2 == 0) {
                tttMatrix[posicao] = "O"
            } else {
                tttMatrix[posicao] = "X"
            }
        }
        
        let result = existeVencedor(tttMatrix)
        
        if(result.0) {
            return result.1 // X: caso X ganhe | O: caso O ganhe
        }
        
        if(jogadas.count == 9) { // Empate se ninguém ganhou e número de jogadas for igual a 9
            return "E"
        }
        
        return "I"
    }
    
    static func casasIguais(_ a: String, _ b: String, _ c: String) -> Bool {
        if(a.isEmpty || b.isEmpty || c.isEmpty) {
            return false
        }
        
        return a == b && b == c
    }
    
    static func existeVencedor(_ matrix: [String]) -> (Bool, String) {
        if(casasIguais(matrix[0], matrix[1], matrix[2])) {
            return (true, matrix[0])
        } else if(casasIguais(matrix[3], matrix[4], matrix[5])) {
            return (true, matrix[3])
        } else if(casasIguais(matrix[6], matrix[7], matrix[8])) {
            return (true, matrix[6])
        } else if(casasIguais(matrix[0], matrix[3], matrix[6])) {
            return (true, matrix[0])
        } else if(casasIguais(matrix[1], matrix[4], matrix[7])) {
            return (true, matrix[1])
        } else if(casasIguais(matrix[2], matrix[5], matrix[8])) {
            return (true, matrix[2])
        } else if(casasIguais(matrix[0], matrix[4], matrix[8])) {
            return (true, matrix[0])
        } else if(casasIguais(matrix[2], matrix[4], matrix[6])) {
            return (true, matrix[2])
        } else {
            return (false, "")
        }
    }
}
