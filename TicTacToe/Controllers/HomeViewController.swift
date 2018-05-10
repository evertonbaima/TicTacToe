//
//  HomeViewController.swift
//  TicTacToe
//
//  Created by Everton Baima on 06/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit
import FirebaseAuth

public class HomeViewController: UIViewController {
    var autenticacao:Auth!
    @IBOutlet weak var btnBuscarPartida: UIButton!
    @IBOutlet weak var btnHistoricoPartidas: UIButton!
    @IBOutlet weak var btnSair: UIButton!
    
    @IBAction func btnSair(_ sender: Any) {
        do{
            try self.autenticacao.signOut()
            self.performSegue(withIdentifier: "redirectLoginSegue", sender: nil)
        }catch {
            print("Erro ao deslogar usuario")
        }
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.autenticacao = Auth.auth()
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario == nil {
                self.performSegue(withIdentifier: "redirectLoginSegue", sender: nil)
            }
        }
        
        btnBuscarPartida.layer.cornerRadius = 15
        btnHistoricoPartidas.layer.cornerRadius = 15
        btnSair.layer.cornerRadius = 15
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
