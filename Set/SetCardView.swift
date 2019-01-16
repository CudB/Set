//
//  SetCardView.swift
//  Set
//
//  Created by Andy Au on 2019-01-10.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    var type = SetCard.Symbol.squiggle
    var color = SetCard.Color.blue
    var number = SetCard.Number.three
    var shading = SetCard.Shading.striped
    
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
        for i in 0..<grid.cellCount {
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()
                drawSymbol(type: type, color: color, shading: shading, inGrid: grid, inCellNumber: i)
                context.restoreGState()
            }
        }
    }
    
    private func drawSymbol(type: SetCard.Symbol, color: SetCard.Color, shading: SetCard.Shading, inGrid grid: Grid, inCellNumber cell: Int) {
        
        let symbolContainer = CGRect(origin: calculateSymbolOrigin(within: grid, cell: cell), size: calculateSymbolSize(within: grid))
        
        var symbolColor: UIColor
        var symbolPath: UIBezierPath
        var shadingPath: UIBezierPath
        
        
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
            symbolPath = drawOval(in: symbolContainer)
        case .diamond:
            symbolPath = drawDiamond(in: symbolContainer)
        case .squiggle:
            symbolPath = drawSquiggle(in: symbolContainer)
        }
        
        switch shading {
        case .open:
            symbolColor.setStroke()
            symbolPath.stroke()
        case .solid:
            symbolColor.setFill()
            symbolPath.fill()
        case .striped:
            symbolColor.setStroke()
            symbolPath.stroke()
            shadingPath = drawStripes(in: symbolContainer, for: symbolPath)
            shadingPath.stroke()
            symbolPath.addClip()
            
        }
    }
    
    private func drawOval(in rect: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: rect)
    }
    
    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: rect.origin.offsetBy(dx: rect.width/2, dy: 0))
        diamond.addLine(to: diamond.currentPoint.offsetBy(dx: rect.width/2, dy: rect.height/2))
        diamond.addLine(to: diamond.currentPoint.offsetBy(dx: -rect.width/2, dy: rect.height/2))
        diamond.addLine(to: diamond.currentPoint.offsetBy(dx: -rect.width/2, dy: -rect.height/2))
        return diamond
    }
    
    private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
        // Drawing this curve was the most asinine thing I have ever done. I'm sure there's a clever way to figure out the numbers for these curves and I've just wasted my time.
        let squiggle = UIBezierPath()
        squiggle.move(to: rect.origin.offsetBy(dx: rect.width * 0.15, dy: rect.height * 0.87))
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width, dy: rect.height * 0.5),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 0.5, dy: rect.height * 0.4),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.75, dy: rect.height * 1.3)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width * 0.85, dy: rect.height * 0.1),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 1.1, dy: rect.height * 0.07),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.9, dy: rect.height * -0.03)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: 0, dy: rect.height * 0.5),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 0.5, dy: rect.height * 0.6),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.2, dy: rect.height * -0.4)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width * 0.15, dy: rect.height * 0.87),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * -0.1, dy: rect.height * 0.9),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.1, dy: rect.height * 0.95)
        )
        return squiggle
    }
    
    private func drawStripes(in rect: CGRect, for symbol: UIBezierPath) -> UIBezierPath {
        let stripes = UIBezierPath()
        stripes.move(to: rect.origin)
        for x in stride(from: floor(rect.origin.x - 10), to: floor(rect.origin.x + rect.width + 10), by: 1) {
            if x.truncatingRemainder(dividingBy: 4) == 0 {
                stripes.move(to: CGPoint(x: CGFloat(x), y: rect.origin.y))
                stripes.addLine(to: CGPoint(x: CGFloat(x), y: rect.origin.y + rect.height))
            }
        }
        symbol.addClip()
        return stripes
    }
    
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
