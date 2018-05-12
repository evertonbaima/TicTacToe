//
//  HistoricoPartidasTableViewController.swift
//  TicTacToe
//
//  Created by Arleson  on 09/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HistoricoPartidasTableViewController: UITableViewController {
    private let ref: DatabaseReference = Database.database().reference()
    private let auth: Auth = Auth.auth()
    
    private var historico: [Partida] = []
    private var idJogador: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.idJogador = EncodeDecodeUtils.encodeBase64(text: (self.auth.currentUser?.email)!)
        
        self.ref.child("/jogadores/\(self.idJogador)/partidas").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let c = child.value as! NSDictionary
                
                self.historico.append(Partida(
                    data: self.stringToDatetime(c["data"] as! String)!,
                    idOponente: c["id_oponente"] as! String,
                    resultado: c["resultado"] as! String
                ))
             
                self.historico.sort(by: { (p1, p2) -> Bool in return p1.data! > p2.data! })
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historico.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historicoCell", for: indexPath) as! HistoricoPartidasTableViewCell

        let partida = self.historico[indexPath.row]
        
        self.ref.child("jogadores/\(partida.idOponente)").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            cell.dataPartida.text = self.datetimeToString(partida.data!)
            cell.nomeJogador.text = value?["nome"] as? String
            cell.resultado.image = UIImage(named: (partida.resultado == "V" ? "Vitoria" : "Derrota"))
        }

        return cell
    }
    
    private func stringToDatetime(_ date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter.date(from: date)
    }
    
    private func datetimeToString(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        return formatter.string(from: date)
    }
}
