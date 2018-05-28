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
        self.verificaNomesPlayers()
        
        jogador1 = idjogador1
        jogador2 = idjogador2
        
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
        verificaUltimaJogada()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func atualizaJogada() {
        self.jogadas.removeAll()
        self.reference.child("/salas/\(self.idSala)/jogadas").observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let c = child.value as! NSDictionary
                if let data = c["data"] {
                    if let tupla = c["jogada"] {
                        let resTuple = self.convertTuple(tupla as! String)
                        if let idPlayer = c["id_jogador"] {
                            self.jogadas.append(Jogada(data: data as! String, jogada: resTuple, idJogador: idPlayer as! String))
                            self.verificaClick()
                        }
                    }
                }
            }
        }
    }
    
    func verificaNomesPlayers() {
        self.reference.child("/jogadores/\(idjogador1)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let c = snapshot.value as? NSDictionary {
                self.nomeJogador1.text = (c["nome"] as! String)
                self.nomeJogadorVez.text = (c["nome"] as! String)
            }
        })
        
        self.reference.child("/jogadores/\(idjogador2)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let c = snapshot.value as? NSDictionary {
                self.nomeJogador2.text = (c["nome"] as! String)
            }
        })
    }
    
    func verificaUltimaJogada() {
        let emailB64 = EncodeDecodeUtils.encodeBase64(text: (self.auth.currentUser?.email)!)
        self.reference.child("/salas/\(idSala)/jogadas").queryLimited(toLast: 1).observe(.value) { (snapshot) in
            if !snapshot.hasChild("jogadas") {
                if emailB64 != self.idjogador1 {
                    self.disableButton()
                }
            }
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let c = child.value as! NSDictionary
                if self.idjogador1 != c["id_jogador"] as! String {
                    self.play += 0
                    self.nomeJogadorVez.text = self.nomeJogador1.text
                    if emailB64 == self.idjogador2 {
                        self.disableButton()
                    }else {
                        self.enableButton()
                    }
                }else {
                    self.play += 1
                    self.nomeJogadorVez.text = self.nomeJogador2.text
                    if emailB64 == self.idjogador1 {
                        self.disableButton()
                    }else {
                        self.enableButton()
                    }
                }
            }
        }
    }
    
    func convertTuple(_ string: String) -> (Int,Int) {
        let pureValue = string.replacingOccurrences(of: "\"", with: "", options: .caseInsensitive, range: nil).replacingOccurrences(of: "(", with: "", options: .caseInsensitive, range: nil).replacingOccurrences(of: ")", with: "", options: .caseInsensitive, range: nil)
        let array = pureValue.components(separatedBy: ", ")
        return (Int(array[0])!, Int(array[1])!)
    }
    
    func verificaClick() {
        for i in 0...(game.count - 1) {
            for j in 0...(game[i].count - 1) {
                for jogada in self.jogadas {
                    if jogada.jogada == decodeTuple(click: game[i][j].tag) {
                        if idjogador1 == jogada.idJogador {
                            game[i][j].setTitleColor(.red, for: .normal)
                            game[i][j].setTitle("X", for: .normal)
                        }else {
                            game[i][j].setTitleColor(.blue, for: .normal)
                            game[i][j].setTitle("O", for: .normal)
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
    
    func enableButton() {
        for i in 0...(game.count - 1) {
            for j in 0...(game[i].count - 1) {
                game[i][j].isEnabled = true
            }
        }
    }
    
    private func stringToDatetime(data: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: data)
    }
    
    func decodeTuple(click:Int) -> (Int,Int) {
        var tupla:(Int,Int)
        switch click {
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
        return tupla
    }
    
    @objc func buttonClick(sender: UIButton!) {
        let title = sender.title(for: .normal)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"
        let currentDate = formatter.string(from: date)
        
        var jogada: Dictionary<String,String> = [:]
        var jogada2:Jogada? = nil
        
        if (title == "X" || title == "O") { return }
        
        let tupla = decodeTuple(click: (sender as UIButton).tag)
        
        if (play % 2 == 0) {
            sender.setTitleColor(.red, for: .normal)
            sender.setTitle("X", for: .normal)
            self.nomeJogadorVez.text = self.nomeJogador2.text
            self.nomeJogadorVencedor.text = "AGUARDE..."
            jogada = [ "data":"\(currentDate)","jogada":"\(tupla)","id_jogador":"\(self.jogador1)" ]
            jogada2 = (Jogada(data: currentDate, jogada: tupla, idJogador: self.jogador1))
            let ref = reference.child("salas").child("\(idSala)").child("jogadas").child("\(jogadas.count)")
            ref.setValue(jogada)
        } else {
            sender.setTitleColor(.blue, for: .normal)
            sender.setTitle("O", for: .normal)
            self.nomeJogadorVez.text = self.nomeJogador1.text
            self.nomeJogadorVencedor.text = "AGUARDE..."
            jogada = [ "data":"\(currentDate)","jogada":"\(tupla)","id_jogador":"\(self.jogador2)" ]
            jogada2 = (Jogada(data: currentDate, jogada: tupla, idJogador: self.jogador2))
            let ref = reference.child("salas").child("\(idSala)").child("jogadas").child("\(jogadas.count)")
            ref.setValue(jogada)
        }
        jogadas.append(jogada2!)
        
        let statusPartida = Game.verificarStatusDeJogo(jogadas)
        //print(statusPartida)
        if statusPartida == "X" {
            AlertUtils.victoryAlert(status: statusPartida, nomeGanhador: self.nomeJogador1.text!, self)
            self.nomeJogadorVencedor.text = "\(self.nomeJogador1.text!) WINS"
        }else if statusPartida == "O" {
            AlertUtils.victoryAlert(status: statusPartida, nomeGanhador: self.nomeJogador2.text!, self)
            self.nomeJogadorVencedor.text = "\(self.nomeJogador2.text!) WINS"
        }else if statusPartida == "E" {
            AlertUtils.victoryAlert(status: statusPartida, nomeGanhador: self.nomeJogador1.text!, self)
            self.nomeJogadorVencedor.text = "Empate"
        }
        
        play += 1
    }
}
