//
//  Canvas.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 21.01.2021.
//

import Foundation
import RxSwift

struct ActionData {
    let index: Int
    let shape: Shape
}

enum ActionType {
    case addedShape(ActionData)
    case deletedShape(ActionData)
}

enum CanvasError: Error {
    case outOfRange
}

class Canvas {
    var actionOnShape: Observable<ActionType> {
        get {
            _actionOnShape
        }
    }
    var shapeCount: Int {
        self.shapes.count
    }
    
    private var shapes: [Shape]
    private var _actionOnShape = PublishSubject<ActionType>()
    
    init(shapes: [Shape]) {
        self.shapes = shapes
    }
    
    func appendShape(_ shape: Shape) {
        shapes.append(shape)
        _actionOnShape.onNext(.addedShape(.init(index: shapeCount, shape: shape)))
    }
    
    func insertShapeByIndex(_ index: Int, shape: Shape) {
        shapes.insert(shape, at: index)
        _actionOnShape.onNext(.addedShape(.init(index: index, shape: shape)))
    }
    
    func deleteShapeByIndex(_ index: Int) throws {
        guard let shape = try? getShapeByIndex(index) else {
            throw CanvasError.outOfRange
        }
        _actionOnShape.onNext(.deletedShape(.init(index: index, shape: shape)))
    }
    
    private func getShapeByIndex(_ index: Int) throws -> Shape {
        guard isIndexInShapesRange(index) else {
            throw CanvasError.outOfRange
        }
        return shapes[index]
    }
    
}

extension Canvas {
    private func isIndexInShapesRange(_ index: Int) -> Bool {
        index >= 0 && index < self.shapeCount
    }
}
