//
//  CGPoint+OffsetPointBy.swift
//  Set
//
//  Created by Andy Au on 2019-01-16.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
