//
//  BackgroundView.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 23.01.2021.
//

import Foundation
import UIKit
import RxSwift

class BackgroundView: UIView {
    var selectedShapeHandler: SelectedShapeHandler?
    private var selfFrame: Rect {
        Rect(leftTop: .init(x: Double(self.frame.minX), y: Double(self.frame.minY)), size: .init(width: Double(self.frame.width), hegiht: Double(self.frame.height)))
    }
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        selectedShapeHandler?(selfFrame)
    }
    
    func subscriveViewModel(state: Observable<Rect>) {
        state.subscribe(
            onNext: { value in
                self.frame = CGRect(x: value.leftTop.x, y: value.leftTop.y, width: value.size.width, height: value.size.hegiht)
            }
        ).disposed(by: disposeBag)
    }
    
    
}
