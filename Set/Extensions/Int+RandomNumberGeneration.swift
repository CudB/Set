//
//  Int+RandomNumberGeneration.swift
//  Concentration
//
//  Created by Andy Au on 2018-09-17.
//  Copyright © 2018 Standford University. All rights reserved.
//

import Foundation

extension Int {
    // Generates a random number using arc4random.
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
