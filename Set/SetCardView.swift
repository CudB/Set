//
//  SetCardView.swift
//  Set
//
//  Created by Andy Au on 2019-01-10.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        // Create the card boundaries.
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        // Create a grid within the card.
        let gridFrame = CGRect(origin: gridFrameOrigin, size: gridFrameSize)
        var grid = Grid(layout: Grid.Layout.dimensions(rowCount: 3, columnCount: 1), frame: gridFrame)
        
        // Draw symbol(s) within the grid.
        for i in 0..<grid.cellCount { drawSymbol(type: SetCard.Symbol.squiggle, color: SetCard.Color.blue, shading: SetCard.Shading.solid, inGrid: grid, inCellNumber: i) }
    }
    
}

extension SetCardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let gridSizeToBoundsSize: CGFloat = 0.6
        static let symbolSizeToGridCellSize: CGFloat = 0.8
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var gridFrameOrigin: CGPoint {
        return CGPoint(x: (bounds.size.width - bounds.size.width * SizeRatio.gridSizeToBoundsSize)/2.0, y: (bounds.size.height - bounds.size.height * SizeRatio.gridSizeToBoundsSize)/2.0)
    }
    private var gridFrameSize: CGSize {
        return CGSize(width: bounds.width * SizeRatio.gridSizeToBoundsSize, height: bounds.height * SizeRatio.gridSizeToBoundsSize)
    }
    
    private func calculateSymbolOrigin(within grid: Grid, cell: Int) -> CGPoint {
        return CGPoint(x: grid.frame.origin.x + (grid.cellSize.width - grid.cellSize.width * SizeRatio.symbolSizeToGridCellSize)/2.0, y: grid.frame.origin.y + (grid.cellSize.height - grid.cellSize.height * SizeRatio.symbolSizeToGridCellSize)/2.0 + grid.cellSize.height * CGFloat(cell))
    }
    
    private func calculateSymbolSize(within grid: Grid) -> CGSize {
        return CGSize(width: grid.cellSize.width * SizeRatio.symbolSizeToGridCellSize, height: grid.cellSize.height * SizeRatio.symbolSizeToGridCellSize)
    }
    
    private func drawSymbol(type: SetCard.Symbol, color: SetCard.Color, shading: SetCard.Shading, inGrid grid: Grid, inCellNumber cell: Int) {
        let symbolContainer = CGRect(origin: calculateSymbolOrigin(within: grid, cell: cell), size: calculateSymbolSize(within: grid))
        
        var symbolColor: UIColor
        
        
        switch color {
        case .red:
            symbolColor = UIColor.red
        case .green:
            symbolColor = UIColor.green
        case .blue:
            symbolColor = UIColor.blue
        }
        
        switch type {
        case .oval:
            symbolColor.setFill()
            drawOval(in: symbolContainer)
        case .diamond:
            break
        case .squiggle:
            symbolColor.setStroke()
            drawSquiggle(in: symbolContainer)
        }
    }
    
    private func drawOval(in rect: CGRect) {
        let oval = UIBezierPath(ovalIn: rect)
        oval.fill()
    }
    
    private func drawSquiggle(in rect: CGRect) {
        // Drawing this curve was the most asinine thing I have ever done. I'm sure there's a clever way to figure out the numbers for these curves and I've just wasted my time.
        let squiggle = UIBezierPath()
        
        squiggle.move(to: rect.origin.offsetBy(dx: rect.width * 0.15, dy: rect.height * 0.87))
        
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width, dy: rect.height * 0.5),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 0.50, dy: rect.height * 0.4),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.75, dy: rect.height * 1.30)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width * 0.85, dy: rect.height * 0.1),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 1.1, dy: rect.height * 0.07),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.9, dy: rect.height * -0.03)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: 0, dy: rect.height * 0.5),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 0.50, dy: rect.height * 0.6),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.2, dy: rect.height * -0.40)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width * 0.15, dy: rect.height * 0.87),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * -0.1, dy: rect.height * 0.9),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.1, dy: rect.height * 0.95)
        )
        
        squiggle.stroke()
    }
    
    
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension CGRect {
    func center() -> CGPoint {
        return origin.offsetBy(dx:width/2, dy:height/2)
    }
}
