//
//  HomeViewController.swift
//  TicTacToe
//
//  Created by Everton Baima on 06/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit

public class HomeViewController: UIViewController {
    @IBOutlet weak var btnBuscarPartida: UIButton!
    @IBOutlet weak var btnHistoricoPartidas: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        btnBuscarPartida.layer.cornerRadius = 15
        btnHistoricoPartidas.layer.cornerRadius = 15
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
