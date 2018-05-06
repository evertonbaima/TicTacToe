//
//  File.swift
//  TicTacToe
//
//  Created by Arleson  on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import Foundation

class Jogador {
    var id:String
    var nome:String
    var online:Bool
    var partidas:[Partida]
    var idSala:String
    
    
    init(id:String, nome:String, online:Bool, partidas:[Partida], idSala:String) {
        self.id = id
        self.nome = nome
        self.online = online
        self.partidas = partidas
        self.idSala = idSala
    }
    
}
