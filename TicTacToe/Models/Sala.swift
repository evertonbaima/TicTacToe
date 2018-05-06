//
//  Sala.swift
//  TicTacToe
//
//  Created by Arleson  on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import Foundation

class Sala {
    var idSala:String
    var jogadas:[Jogada]
    var idJogador1:String
    var idJogador2:String
    
    init(idSala:String, jogadas:[Jogada], idJogador1:String, idJogador2:String) {
        self.idSala = idSala
        self.jogadas = jogadas
        self.idJogador1 = idJogador1
        self.idJogador2 = idJogador2
    }
    
}
