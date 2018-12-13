//
//  SetCard.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

class SetCard : Card 
{
    let number: Number
    let symbol: Symbol
    let color: Color
    let shading: Shading
    
    init(number: Number, symbol: Symbol, color: Color, shading: Shading) {
        self.number = number
        self.color = color
        self.symbol = symbol
        self.shading = shading
    }
}
