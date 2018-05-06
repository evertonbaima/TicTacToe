//
//  LoginViewController.swift
//  TicTacToe
//
//  Created by Everton Baima on 06/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit

public class LoginViewController: UIViewController {
    @IBOutlet weak var btnEntrar: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        btnEntrar.layer.cornerRadius = 15
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
