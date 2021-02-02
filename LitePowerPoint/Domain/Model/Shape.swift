//
//  Shape.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 21.01.2021.
//

import Foundation
import RxSwift

enum ShapeType {
    case triangle
    case ellipse
    case rectangle
}

class Shape {
    var stateFrame: Observable<Rect> {
        get {
            _stateFrame
        }
    }
    let id: String
    let type: ShapeType
    let color: UIColor
    private var frame: Rect
    private var _stateFrame = PublishSubject<Rect>()
    
    init(frame: Rect, type: ShapeType) {
        self.id = createRandomShapeId()
        self.frame = frame
        self.type = type
        self.color = .random()
        self._stateFrame.onNext(self.frame)
    }
    
    func getFrame() -> Rect {
        self.frame
    }
    
    func doOnChangeFrame(_ frame: Rect) {
        guard self.frame != frame else {
            return
        }
        self.frame = frame
        self._stateFrame.onNext(self.frame)
    }
    
}

fileprivate func createRandomShapeId(_ length: Int = 10) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}


