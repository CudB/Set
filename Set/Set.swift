//
//  Set.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Standford University. All rights reserved.
//

import Foundation

struct Set {
    private(set) var cards = [SetCard]()
    
    mutating func startNewGame() {
    }
    
    init() {
        for number in Number.allCases {
            for shape in Shape.allCases {
                for color in Color.allCases {
                    for shading in Shading.allCases {
                        let card = SetCard(number: number, shape: shape, color: color, shading: shading)
                        cards += [card]
                    }
                }
            }
        }
        startNewGame()
    }
}

enum Number: CaseIterable {
    case one, two, three
}
enum Shape: CaseIterable {
    case triangle, circle, square
}
enum Color: CaseIterable {
    case red, green, blue
}
enum Shading: CaseIterable {
    case open, striped, solid
}
