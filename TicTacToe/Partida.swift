//
//  Partida.swift
//  TicTacToe
//
//  Created by Arleson  on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import Foundation

class Partida {
    var data:Date
    var idOponente:String
    var resultado:Character // V - vitoria D - derrota E - empate
    
    init(data:Date, idOponente:String, resultado:Character) {
        self.data = data
        self.idOponente = idOponente
        self.resultado = resultado
    }
}
