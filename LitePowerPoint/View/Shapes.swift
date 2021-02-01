//
//  Shapes.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 23.01.2021.
//

import Foundation
import UIKit

fileprivate let defaultColor = UIColor.black

class EllipseView: UIView {
    private var color: UIColor = defaultColor
    
    override func draw(_ rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        self.color.setFill()
        ovalPath.fill()
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
    }
}

class RectangleView: UIView {
    private var color: UIColor = defaultColor
    
    override func draw(_ rect: CGRect) {
        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: .init(x: rect.minX, y: rect.minY))
        rectanglePath.addLine(to: .init(x: rect.maxX, y: rect.minY))
        rectanglePath.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        rectanglePath.addLine(to: .init(x: rect.minX, y: rect.maxY))
        rectanglePath.addLine(to: .init(x: rect.minX, y: rect.minY))
        self.color.setFill()
        rectanglePath.fill()
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
    }
}

class TriangleView: UIView {
    private var color: UIColor = defaultColor
    
    override func draw(_ rect: CGRect) {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: .init(x: rect.minX, y: rect.maxY))
        trianglePath.addLine(to: .init(x: rect.midX, y: rect.minY))
        trianglePath.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        trianglePath.addLine(to: .init(x: rect.minX, y: rect.maxY))
        self.color.setFill()
        trianglePath.fill()
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
    }
}
