//
//  ShapeAppModel.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 21.01.2021.
//

import Foundation
import RxSwift

class ShapeAppModel {
    var viewState: Observable<Rect> {
        get {
            _viewState
        }
    }
    var frame: Rect {
        get {
            shape.getFrame()
        }
    }
    var type: ShapeType {
        get {
            shape.type
        }
    }
    var color: UIColor {
        get {
            shape.color
        }
    }
    
    var id: String {
        get {
            shape.id
        }
    }
    
    private var _viewState = PublishSubject<Rect>()
    private let shape: Shape
    private let disposeBag = DisposeBag()
    
    
    init(shape: Shape) {
        self.shape = shape
        subscribeDomainModel(self.shape.stateFrame)
    }
    
    func doOnChangeFrame(_ frmae: Rect) {
        shape.doOnChangeFrame(frmae)
    }
    
    private func subscribeDomainModel(_ state: Observable<Rect>) {
        state.subscribe(
            onNext: { value in
                self._viewState.onNext(value)
            }
        ).disposed(by: disposeBag)
    }
    
}
