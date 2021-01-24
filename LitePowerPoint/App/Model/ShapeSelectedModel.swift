//
//  ShapeSelectedModel.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 23.01.2021.
//

import Foundation
import RxSwift
import UIKit

enum SelectionViewModelError: Error {
    case shapeByIdNotFound
}

enum SelectionActionViewState {
    case addSelection(ShapeAppModel)
    case removeSelection(Int)
}

class ShapeSelectedModel {
    var viewState: Observable<SelectionActionViewState> {
        get {
            _viewState
        }
    }
    
    var shapesIds: [String] {
        get {
            self.selectedShapes.map({
                $0.id
            })
        }
    }
    
    var selectedShapeHandler: SelectedShapeHandler?
    private var selectedShapes = [ShapeAppModel]()
    private var _viewState = PublishSubject<SelectionActionViewState>()
    
    func addShape(_ shape: ShapeAppModel) {
        self.selectedShapes.append(shape)
        self._viewState.onNext(.addSelection(shape))
    }
    
    func removeSelection(shapeId: String) throws {
        guard let index = findOneShapeIndexById(shapeId) else {
            throw SelectionViewModelError.shapeByIdNotFound
        }
        self.selectedShapes.remove(at: index)
    }
    
//    func cleanSelection() {
//        self.selectedShapes.removeAll()
//    }
    
}

extension ShapeSelectedModel {
    private func findOneShapeIndexById(_ shapeId: String) -> Int? {
        self.selectedShapes.firstIndex(where: { $0.id == shapeId })
    }
}
