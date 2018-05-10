//
//  CadastroViewController.swift
//  TicTacToe
//
//  Created by Everton Baima on 06/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

public class CadastroViewController: UIViewController {
    var usuario:[Jogador] = []
    
    @IBOutlet weak var btnSalvarCadastro: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmaSenha: UITextField!
    
    @IBAction func salvarCadastro(_ sender: Any) {
        if let emailR = self.email.text {
            if let nomeR = self.nome.text {
                if let senhaR = self.senha.text {
                    if let confirmaSenhaR = self.confirmaSenha.text {
                        if senhaR == confirmaSenhaR {
                            let autenticacao = Auth.auth()
                            let reference = Database.database().reference()
                            autenticacao.createUser(withEmail: emailR, password: senhaR) { (usuario, erro) in
                                if erro == nil {
                                    if usuario == nil {
                                        AlertUtils.mensagemValidacao(titulo: "Erro ao autenticar", mensagem: "\n Problema ao realizar autenticação, tente novamente!", self)
                                    }else {
                                        //AlertUtils.mensagemValidacao(titulo: "Cadastro de usuário", mensagem: "\n Usuário cadastrado com sucesso!", self)
                                        let emailB64 = EncodeDecodeUtils.encodeBase64(text: emailR)
                                        let jogadores = reference.child("jogadores").child(emailB64)
                                        let usuario = ["email":"\(emailR)",
                                                       "nome":"\(nomeR)",
                                                       "online":"true",
                                                       "id_sala":""
                                                      ]
                                        jogadores.setValue(usuario)
                                        self.performSegue(withIdentifier: "cadastroSegue", sender: nil)
                                    }
                                }else {
                                    let erroR = erro! as NSError
                                    if let codigoErroR = erroR.userInfo["error_name"] {
                                        let erroTextoR = codigoErroR as! String
                                        var mensagemErro = ""
                                        switch erroTextoR {
                                        case "ERROR_INVALID_EMAIL": mensagemErro = "\n E-mail inválido!"
                                            break
                                        case "ERROR_WEAK_PASSWORD": mensagemErro = "\n Senha precisa ter no mínimo 6 caracteres!"
                                            break
                                        case "ERROR_EMAIL_ALREADY_IN_USE": mensagemErro = "\n E-mail já cadastrado!"
                                            break
                                        default: mensagemErro = "\n Dados incorretos!"
                                        }
                                        AlertUtils.mensagemValidacao(titulo: "Dados inválidos", mensagem: mensagemErro, self)
                                    }
                                }
                            }
                        }else {
                            AlertUtils.mensagemValidacao(titulo: "Dados incorretos", mensagem: "\n As senhas não estão iguais!", self)
                        }
                    }
                }
            }
        }
    }
    
//    func encodeBase64(text: String) -> String {
//        let dados = text.data(using: String.Encoding.utf8)
//        let dadosB64 = dados!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//
//        return dadosB64
//    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        btnSalvarCadastro.layer.cornerRadius = 15
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
