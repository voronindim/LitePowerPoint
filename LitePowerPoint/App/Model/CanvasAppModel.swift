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
    
    func insertShapeByIndex(_ index: Int, shape: Shape) {
        self.canvas.insertShapeByIndex(index, shape: shape)
    }
    
    func deleteShapeByIndex(_ index: Int) throws {
        guard let _ = try? self.canvas.deleteShapeByIndex(index) else {
            throw CanvasViewModelError.outOfRange
        }
    }
    
    private func subscribeDomainModel(_ state: Observable<ActionType>) {
        state.subscribe(
            onNext: { value in
                self._viewState.onNext(createNewActionTypeValue(type: value))
            }
        ).disposed(by: disposeBag)
    }
}

private func createNewActionTypeValue(type: ActionType) -> ViewActionType {
    switch type {
    case .addedShape(let data):
        return .addedShape(.init(index: data.index, shape: .init(shape: data.shape)))
    case .deletedShape(let data):
        return .deletedShape(.init(index: data.index, shape: .init(shape: data.shape)))
    }
}



