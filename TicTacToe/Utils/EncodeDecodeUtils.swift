//
//  EncodeDecodeUtils.swift
//  TicTacToe
//
//  Created by Arleson  on 09/05/2018.
//  Copyright © 2018 UNI7. All rights reserved.
//

import UIKit

public class EncodeDecodeUtils {
    public static func encodeBase64(text: String) -> String {
        let dados = text.data(using: String.Encoding.utf8)
        let dadosB64 = dados!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return dadosB64
    }
    
}
