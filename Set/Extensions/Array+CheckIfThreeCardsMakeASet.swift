//
//  Array+CheckIfThreeCardsMakeASet.swift
//  Set
//
//  Created by Andy Au on 2018-12-18.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

extension Array where Element == SetCard {
    // Checks the first three cards in an array of SetCard and sees if they form a set.
    var successfulMatch: Bool {
        if sameOrAllDifferent(self[0].color, self[1].color, self[2].color) &&
                sameOrAllDifferent(self[0].symbol, self[1].symbol, self[2].symbol) &&
                sameOrAllDifferent(self[0].shading, self[1].shading, self[2].shading) &&
                sameOrAllDifferent(self[0].number, self[1].number, self[2].number) {
            return true
        }
        return false
    }
}

// TODO: Move this to own extension/helper??
private func sameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
    if (a == b && a == c) || (a != b && a != c && b != c) {
        return true
    }
    return false
}
