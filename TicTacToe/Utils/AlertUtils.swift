//
//  AlertUtils.swift
//  TicTacToe
//
//  Created by Everton Baima on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit

public class AlertUtils {
    public static func victoryAlert(_ controller: UIViewController) {
        let alert = UIAlertController(title: "Blá", message: "Yoooooow!", preferredStyle: .alert)

        alert.view.tintColor = UIColor.white
        alert.view.backgroundColor = UIColor.black
        alert.view.layer.cornerRadius = 25

        controller.present(alert, animated: true, completion: nil)
    }
    
    public static func mensagemValidacao(titulo:String, mensagem:String,_ controller: UIViewController) {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(acaoCancelar)
        controller.present(alerta, animated: true, completion: nil)
    }
    
}
