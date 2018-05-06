//
//  AlertUtils.swift
//  TicTacToe
//
//  Created by Everton Baima on 28/04/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit

public class AlertUtils {
    public static func victoryAlert(_ controller: UIViewController) {
        let alert = UIAlertController(title: "Blá", message: "Yoooooow!", preferredStyle: .alert)

        alert.view.tintColor = UIColor.white
        alert.view.backgroundColor = UIColor.black
        alert.view.layer.cornerRadius = 25

        controller.present(alert, animated: true, completion: nil)
    }
}
