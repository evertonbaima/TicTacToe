//
//  JogadoresOnlineTableViewController.swift
//  TicTacToe
//
//  Created by Arleson  on 09/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

class JogadoresOnlineTableViewController: UITableViewController, UISearchBarDelegate {

    var searchActive:Bool = false
    var filtered:[Jogador] = []
    var sala:[Sala] = []
    var jogadoresOnline:[Jogador] = []
    var autenticacao:Auth!
    var reference:DatabaseReference!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reference = Database.database().reference()
        self.autenticacao = Auth.auth()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.atualizaJogadores()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func atualizaJogadores() {
        let userLogado = autenticacao.currentUser?.email;
        let ref = self.reference.child("jogadores")
        ref.observe(.value) { (snapshot) in
            self.jogadoresOnline.removeAll()
            for jogadores in snapshot.children.allObjects as! [DataSnapshot] {
                let dados = jogadores.value as? NSDictionary
                if let email = dados!["email"] {
                    if let idSala = dados!["id_sala"] {
                        if let nome = dados!["nome"] {
                            if let online = dados!["online"] {
                                if (online as! String) == "true" && (email as! String) != userLogado && (idSala as! String) == "" {
                                    let emailB64 = EncodeDecodeUtils.encodeBase64(text: email as! String)
                                    let jogador = Jogador(id: emailB64,
                                                          nome: nome as! String,
                                                          online: true,
                                                          partidas: [Partida](),
                                                          idSala: idSala as! String)
                                    self.jogadoresOnline.append(jogador)
                                }else if (idSala as! String) != "" && (email as! String) == userLogado {
                                    let alert = UIAlertController(title: "Convite para jogar \n TIC TAC TOE", message: "\n Deseja jogar uma partida de TIC TAC TOE com o jogador \(nome)?", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { action in
                                        print("aceitou convite")
                                    }))
                                    alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { action in
                                        print("não aceitou convite")
                                    }))
                                    self.present(alert, animated: true)
                                }
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        print("searchBarSearchButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = jogadoresOnline.filter({ (text) -> Bool in
            let tmp = text
            let range = tmp.nome.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return (range != nil)
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Jogadores Online - \(jogadoresOnline.count)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return jogadoresOnline.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCelJogador", for: indexPath)
        let jogador:Jogador
        
        if(searchActive){
            jogador = self.filtered[indexPath.row]
            cell.textLabel?.text = jogador.nome
        } else {
            jogador = self.jogadoresOnline[indexPath.row]
            cell.textLabel?.text = jogador.nome
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let jogador:Jogador
        if(searchActive){
            jogador = self.filtered[indexPath.row]
            print(jogador.nome)
        } else {
            jogador = self.jogadoresOnline[indexPath.row]
            print(jogador.nome)
        }
        let userLogado = autenticacao.currentUser?.email;
        let emailB64UserLogado = EncodeDecodeUtils.encodeBase64(text: userLogado!)
        let emailJogador2B64 = jogador.id
        let salas = self.reference.child("salas").childByAutoId()
        let idSala = salas.key
        let sala = [ "id_jogador1": emailB64UserLogado,
                     "id_jogador2": emailJogador2B64
                   ]
        salas.setValue(sala)
        
        let user = self.reference.child("jogadores").child(emailJogador2B64)
        user.updateChildValues(["id_sala" : idSala])
        
        //self.performSegue(withIdentifier: "inicarJogoSegue", sender: nil)
        //timedNotifications(inSeconds: 3) { (success) in
        //    if success {
        //        print("Successfully notification")
        //    }
        //}
    }
    
    func timedNotifications(inSeconds:TimeInterval, completion:@escaping (_ Success:Bool) -> ()) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Teste title"
        content.subtitle = "Teste subtitle"
        content.body = "Teste body content"
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
                print("Erro ao agendar \(request.identifier): \(String(describing: error))")
            }else {
                completion(true)
                print("Notificação \(request.identifier) agendada.")
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
