//
//  CanvasAppModel.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 21.01.2021.
//

import Foundation
import RxSwift

enum CanvasViewModelError: Error {
    case outOfRange
    case shapeNotFoundById
}

struct ActionDataViewState {
    let index: Int
    let shape: ShapeAppModel
}

enum ViewActionType {
    case addedShape(ActionDataViewState)
    case deletedShape(ActionDataViewState)
}

class CanvasAppModel {
    var viewState: Observable<ViewActionType> {
        get {
            _viewState
        }
    }
    private var _viewState =  PublishSubject<ViewActionType>()
    private var shapes = [ShapeAppModel]()
    private let canvas: Canvas
    private let disposeBag = DisposeBag()
    
    init(canvas: Canvas) {
        self.canvas = canvas
        subscribeDomainModel(self.canvas.actionOnShape)
    }
    
    func appendShape(_ shape: ShapeAppModel) {
        self.canvas.appendShape(.init(frame: shape.frame, type: shape.type))
    }
    
    func insertShapeByIndex(_ index: Int, shape: Shape) throws {
        guard let _ = try? self.canvas.insertShapeByIndex(index, shape: shape) else {
            throw CanvasViewModelError.outOfRange
        }
        // TODO:
    }
    
    func deleteShapeByIndex(_ index: Int) throws {
        guard let _ = try? self.canvas.deleteShapeByIndex(index) else {
            throw CanvasViewModelError.outOfRange
        }
        // TODO:
    }
    
    func deleteShapeById(_ id: String) throws {
        guard let index = getShapeIndexWhereId(id) else {
            throw CanvasViewModelError.shapeNotFoundById
        }
        try deleteShapeByIndex(index)
    }
    
    private func subscribeDomainModel(_ state: Observable<ActionType>) {
        state.subscribe(
            onNext: { value in
                self._viewState.onNext(self.handleViewState(type: value))
            }
        ).disposed(by: disposeBag)
    }
    
    private func handleViewState(type: ActionType) -> ViewActionType {
        switch type {
        case .addedShape(let data):
            let shape = ShapeAppModel(shape: data.shape)
            self.shapes.insert(shape, at: data.index)
            return .addedShape(.init(index: data.index, shape: shape))
        case .deletedShape(let data):
            let shape = ShapeAppModel(shape: data.shape)
            self.shapes.remove(at: data.index)
            return .deletedShape(.init(index: data.index, shape: shape))
        }
    }
    
}

extension CanvasAppModel {
    private func getShapeIndexWhereId(_ id: String) -> Int? {
        self.shapes.firstIndex(where: { $0.id == id })
    }
}
