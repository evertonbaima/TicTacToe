//
//  LoginViewController.swift
//  TicTacToe
//
//  Created by Everton Baima on 06/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit
import FirebaseAuth

public class LoginViewController: UIViewController {
    @IBOutlet weak var btnEntrar: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func entar(_ sender: Any) {
        if let emailR = self.email.text {
            if let senhaR = self.senha.text {
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: emailR, password: senhaR) { (usuario, erro) in
                    if erro == nil {
                        if usuario == nil {
                            AlertUtils.mensagemValidacao(titulo: "Erro ao autenticar", mensagem: "\n Problema ao realizar autenticação, tente novamente!", self)
                        }else {
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    }else {
                        AlertUtils.mensagemValidacao(titulo: "Dados incorretos", mensagem: "\n Verifique os dados digitados e tente novamente!", self)
                    }
                }
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        btnEntrar.layer.cornerRadius = 15
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
