//
//  AlertUtils.swift
//  TicTacToe
//
//  Created by Everton Baima on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit

public class AlertUtils {
    public static func victoryAlert(status: String, nomeGanhador: String, _ controller: UIViewController) {
        let alert: UIAlertController?
        
        if status == "X" || status == "O" {
            alert = UIAlertController(title: "Vitória", message: "Jogador \(nomeGanhador) ganhou a partida", preferredStyle: .alert)
        }else {
            alert = UIAlertController(title: "Empate", message: "A partida foi empate", preferredStyle: .alert)
        }
        alert?.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { action in
            controller.dismiss(animated: true, completion: nil)
        }))

        alert?.view.layer.cornerRadius = 25

        controller.present(alert!, animated: true, completion: nil)
    }
    
    public static func mensagemValidacao(titulo:String, mensagem:String,_ controller: UIViewController) {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(acaoCancelar)
        controller.present(alerta, animated: true, completion: nil)
    }
    
}
