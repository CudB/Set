//
//  SetCard.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Standford University. All rights reserved.
//

import Foundation

class SetCard : Card 
{
    let number: Number
    let shape: Shape
    let color: Color
    let shading: Shading
    
    init(number: Number, shape: Shape, color: Color, shading: Shading) {
        self.number = number
        self.color = color
        self.shape = shape
        self.shading = shading
    }
}
