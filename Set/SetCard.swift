//
//  SetCard.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

//A SetCard consists of four attributes with each attribute having three possible values.
struct SetCard: CustomStringConvertible
{
    var description: String {
        return "\(number) \(shading) \(color) \(symbol)"
    }
    
    var number: Number = .one
    var symbol: Symbol = .oval
    var color: Color = .blue
    var shading: Shading = .open
    
    enum Number: Int, CaseIterable, CustomStringConvertible {
        case one = 1
        case two = 2
        case three = 3
        
        var description: String { return String(rawValue) }
    }
    
    enum Symbol: String, CaseIterable, CustomStringConvertible {
        case oval = "oval"
        case diamond = "diamond"
        case squiggle = "squiggle"
        
        var description: String { return rawValue }
    }
    
    enum Color: String, CaseIterable, CustomStringConvertible {
        case red = "red"
        case green = "green"
        case blue = "blue"
        
        var description: String { return rawValue }
    }
    
    enum Shading: String, CaseIterable, CustomStringConvertible {
        case open = "open"
        case striped = "striped"
        case solid = "solid"
        
        var description: String { return rawValue }
    }
}
