//
//  SetCard.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

class SetCard
{
    let number: Number
    let symbol: Symbol
    let color: Color
    let shading: Shading
    
    // The following enums define possible card attributes.
    enum Number: CaseIterable {
        case one, two, three
    }
    enum Symbol: CaseIterable {
        case triangle, circle, square
    }
    enum Color: CaseIterable {
        case red, green, blue
    }
    enum Shading: CaseIterable {
        case open, striped, solid
    }
    
    init(number: Number, symbol: Symbol, color: Color, shading: Shading) {
        self.number = number
        self.color = color
        self.symbol = symbol
        self.shading = shading
    }
}
