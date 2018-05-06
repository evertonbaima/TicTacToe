//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Everton Baima on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit

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
    
    private var game = [[UIButton]]()
    private var play: Int = 1
    
    @IBAction func customAlert(_ sender: Any) {
        AlertUtils.victoryAlert(self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonClick(sender: UIButton!) {
        let title = sender.title(for: .normal)
        
        if (title == "X" || title == "O") {
            return
        }
        
        if (play % 2 == 0) {
            sender.setTitleColor(.red, for: .normal)
            sender.setTitle("X", for: .normal)
        } else {
            sender.setTitleColor(.blue, for: .normal)
            sender.setTitle("O", for: .normal)
        }
        
        play += 1
    }
}
