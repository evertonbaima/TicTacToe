//
//  Jogada.swift
//  TicTacToe
//
//  Created by Arleson  on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import Foundation

class Jogada {
    var data:Date
    var jogada:(Int,Int)
    var idJogador:String
    
    init(data:Date, jogada:(Int,Int), idJogador:String) {
        self.data = data
        self.jogada = jogada
        self.idJogador = idJogador
        
    }
    
}
