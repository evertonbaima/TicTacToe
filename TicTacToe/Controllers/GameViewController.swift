//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Everton Baima on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

public class GameViewContoller: UIViewController {
    @IBOutlet weak var btn00: UIButton!
    @IBOutlet weak var btn01: UIButton!
    @IBOutlet weak var btn02: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn12: UIButton!
    @IBOutlet weak var btn20: UIButton!
    @IBOutlet weak var btn21: UIButton!
    @IBOutlet weak var btn22: UIButton!
    @IBOutlet weak var nomeJogador1: UILabel!
    @IBOutlet weak var nomeJogador2: UILabel!
    @IBOutlet weak var nomeJogadorVez: UILabel!
    @IBOutlet weak var nomeJogadorVencedor: UILabel!
    
    private var jogadas:[Jogada] = []
    private var game = [[UIButton]]()
    private var play: Int = 0
    public var idSala = String()
    public var idjogador1 = String()
    public var idjogador2 = String()
    private var jogador1 = String()
    private var jogador2 = String()
    private var reference:DatabaseReference!
    private var auth:Auth!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.reference = Database.database().reference()
        self.auth = Auth.auth()
    
        jogador1 = idjogador1
        jogador2 = idjogador2
        
        self.nomeJogador1.text = jogador1
        self.nomeJogador2.text = jogador2
        self.nomeJogadorVez.text = jogador1
        
        game.append([btn00, btn01, btn02])
        game.append([btn10, btn11, btn12])
        game.append([btn20, btn21, btn22])
        
        for i in 0...(game.count - 1) {
            for j in 0...(game[i].count - 1) {
                game[i][j].setTitle("", for: .normal)
                game[i][j].backgroundColor = .clear
                game[i][j].layer.cornerRadius = 10
                game[i][j].layer.borderWidth = 3
                game[i][j].layer.borderColor = UIColor.black.cgColor
                game[i][j].addTarget(self, action: #selector(self.buttonClick), for: .touchUpInside)
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        atualizaJogada()
        indentifierPlayer2()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indentifierPlayer2() {
        let emailB64 = EncodeDecodeUtils.encodeBase64(text: (self.auth.currentUser?.email)!)
        if emailB64 == idjogador2 {
            self.play = 1
        }
    }
    
    func atualizaJogada() {
        self.jogadas.removeAll()
        self.reference.child("/salas/\(self.idSala)/jogadas").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let c = child.value as! NSDictionary
                if let data = self.stringToDatetime(c["data"] as! String) {
                    if let tupla:(Int,Int) = c["jogada"] as? (Int,Int) {
                        if let idPlayer = c["id_jogador"] {
                            self.jogadas.append(Jogada(data: data, jogada: tupla, idJogador: idPlayer as! String))
                            print(self.jogadas)
                        }
                    }
                }
            }
        }
    }
    
    func disableButton() {
        for i in 0...(game.count - 1) {
            for j in 0...(game[i].count - 1) {
                game[i][j].isEnabled = false
            }
        }
    }
    
    private func stringToDatetime(_ date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter.date(from: date)
    }
    
    @objc func buttonClick(sender: UIButton!) {
        let title = sender.title(for: .normal)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"
        let currentDate = formatter.string(from: date)
        
        var jogada: Dictionary<String,String> = [:]
        var jogada2:Jogada? = nil
        
        if (title == "X" || title == "O") {
            return
        }
        
        var tupla:(Int,Int)
        switch (sender as UIButton).tag {
            case 0:
                tupla = (0, 0)
            case 1:
                tupla = (0, 1)
            case 2:
                tupla = (0, 2)
            case 3:
                tupla = (1, 0)
            case 4:
                tupla = (1, 1)
            case 5:
                tupla = (1, 2)
            case 6:
                tupla = (2, 0)
            case 7:
                tupla = (2, 1)
            case 8:
                tupla = (2, 2)
            default:
                tupla = (-1, -1)
        }
        //print(tupla)
        
        if (play % 2 == 0) {
            sender.setTitleColor(.red, for: .normal)
            sender.setTitle("X", for: .normal)
            self.nomeJogadorVez.text = self.nomeJogador2.text
            self.disableButton()
            self.nomeJogadorVencedor.text = "AGUARDE..."
            jogada = [ "data":"\(currentDate)","jogada":"\(tupla)","id_jogador":"\(self.jogador1)" ]
            jogada2 = (Jogada(data: date, jogada: tupla, idJogador: self.jogador1))
            let ref = reference.child("salas").child("\(idSala)").child("jogadas").child("\(jogadas.count)")
            ref.setValue(jogada)
        } else {
            sender.setTitleColor(.blue, for: .normal)
            sender.setTitle("O", for: .normal)
            self.nomeJogadorVez.text = self.nomeJogador1.text
            self.disableButton()
            self.nomeJogadorVencedor.text = "AGUARDE..."
            jogada = [ "data":"\(currentDate)","jogada":"\(tupla)","id_jogador":"\(self.jogador2)" ]
            jogada2 = (Jogada(data: date, jogada: tupla, idJogador: self.jogador2))
            let ref = reference.child("salas").child("\(idSala)").child("jogadas").child("\(jogadas.count)")
            ref.setValue(jogada)
        }
        jogadas.append(jogada2!)
        
        let statusPartida = Game.verificarStatusDeJogo(jogadas)
        print(statusPartida)
        if statusPartida == "X" {
            AlertUtils.victoryAlert(status: statusPartida, nomeGanhador: self.jogador1, self)
            self.nomeJogadorVencedor.text = "\(self.jogador1) WINS"
        }else if statusPartida == "O" {
            AlertUtils.victoryAlert(status: statusPartida, nomeGanhador: self.jogador2, self)
            self.nomeJogadorVencedor.text = "\(self.jogador2) WINS"
        }else if statusPartida == "E" {
            AlertUtils.victoryAlert(status: statusPartida, nomeGanhador: self.jogador1, self)
            self.nomeJogadorVencedor.text = "Empate"
        }
        
        play += 1
    }
}
