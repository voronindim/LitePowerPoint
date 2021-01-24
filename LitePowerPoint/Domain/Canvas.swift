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
        updateState(type: .addedShape(.init(index: shapeCount - 1, shape: shape)))
    }
    
    func insertShapeByIndex(_ index: Int, shape: Shape) throws {
        guard isIndexFromFirstToShapesCount(index) else {
            throw CanvasError.outOfRange
        }
        shapes.insert(shape, at: index)
        updateState(type: .addedShape(.init(index: index, shape: shape)))
    }
    
    func deleteShapeByIndex(_ index: Int) throws {
        guard let shape = try? getShapeByIndex(index) else {
            throw CanvasError.outOfRange
        }
        shapes.remove(at: index)
        updateState(type: .deletedShape(.init(index: index, shape: shape)))
    }
    
    private func getShapeByIndex(_ index: Int) throws -> Shape {
        guard isIndexInShapesRange(index) else {
            throw CanvasError.outOfRange
        }
        return shapes[index]
    }
    
    private func updateState(type: ActionType) {
        switch type {
        case .addedShape(let data):
            _actionOnShape.onNext(.addedShape(data))
        case .deletedShape(let data):
            _actionOnShape.onNext(.deletedShape(data))
        }
    }
    
}

extension Canvas {
    private func isIndexFromFirstToShapesCount(_ index: Int) -> Bool {
        index >= 0 && index <= self.shapeCount
    }
    private func isIndexInShapesRange(_ index: Int) -> Bool {
        index >= 0 && index < self.shapeCount
    }
}
