//
//  ViewController.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 21.01.2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    // MARK: IBOutlet
    
    @IBOutlet var canvasView: UIView!
    
    // MARK: Public Properties
    
    var selectedShapeHandler: SelectedShapeHandler?
    var canvasViewModel = CanvasAppModel(canvas: .init(shapes: []))
    var shapeSelectedModel = SelectionModel()
    
    // MARK: Private Properties
    private var selectionVies = [SelectedView]()
    private var defaultShapeSize: Size {
        .init(width: Double(canvasView.bounds.width / 5), hegiht: Double(canvasView.bounds.height / 5))
    }
    private var defaultShapeFrame: Rect {
        Rect(
            leftTop: .init(
                x: Double(canvasView.bounds.midX) - defaultShapeSize.width / 2,
                y: Double(canvasView.bounds.midY) - defaultShapeSize.hegiht / 2),
            size: defaultShapeSize
        )
    }
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeCanvasViewModel()
        subscribeSelectionViewModel()
    }
    
    // MARK: Public methods
    
    // MARK: Private methods
    
    private func subscribeCanvasViewModel() {
        self.canvasViewModel.viewState.subscribe(
            onNext: { state in
                self.handleCanvasViewState(state: state)
            }
        ).disposed(by: disposeBag)
    }
    
    private func subscribeSelectionViewModel() {
        self.shapeSelectedModel.viewState.subscribe(
            onNext: { state in
                self.handleSelectionViewState(state: state)
            }
        ).disposed(by: disposeBag)
    }
    
    private func createShapeView(type: ShapeType, color: UIColor) -> UIView {
        switch type {
        case .ellipse:
            let shapeView = EllipseView()
            shapeView.setColor(color)
            return shapeView
        case .rectangle:
            let shapeView = RectangleView()
            shapeView.setColor(color)
            return shapeView
        case .triangle:
            let shapeView = TriangleView()
            shapeView.setColor(color)
            return shapeView
        }
    }
    
    private func combineShapeAndBackgroundView(shape: ShapeAppModel) -> UIView {
        let backgroundView = BackgroundView(frame: .init(rect: shape.frame))
        let shapeView = createShapeView(type: shape.type, color: shape.color)
        
        backgroundView.subscriveViewModel(state: shape.viewState)
        
        backgroundView.selectedShapeHandler = {[weak self] frame in
            self?.shapeSelectedModel.addShape(shape)
        }
        
        backgroundView.addSubview(shapeView)
        shapeView.bindFrameToSuperviewBounds()
        
        return backgroundView
    }
    
    private func handleSelectionViewState(state: SelectionActionViewState) {
        switch state {
        case .addSelection(let shape):
            let selectedView = SelectedView(frame: .init(rect: shape.frame))
            canvasView.addSubview(selectedView)
            selectedView.setShapeId(shape.id)
            selectionVies.append(selectedView)
            selectedView.removeSelection = {[weak self] in
                try? self?.shapeSelectedModel.removeSelection(shapeId: shape.id)
                selectedView.removeFromSuperview()
            }
            selectedView.doOnChangeFrame = { frame in
                shape.doOnChangeFrame(frame)
            }
        case .removeSelection(let shapeId):
            print(shapeId)
            selectionVies.first(where: { $0.getShapeId() == shapeId })?.removeFromSuperview()
            try? canvasViewModel.deleteShapeById(shapeId)
        }
    }
    
    private func handleCanvasViewState(state: ViewActionType) {
        switch state {
        case .addedShape(let data):
            let shapeView = combineShapeAndBackgroundView(shape: data.shape)
            canvasView.insertSubview(shapeView, at: data.index)
        case .deletedShape(let data):
            canvasView.subviews[data.index].removeFromSuperview()
        }
    }
    
    private func deleteSelectionShapes() {
        _ = self.shapeSelectedModel.shapesIds.map({
            try? self.shapeSelectedModel.removeSelection(shapeId: $0)
        })
    }
    
    private func appendDefaultShape(_ type: ShapeType) {
        canvasViewModel.appendShape(.init(shape: .init(frame: defaultShapeFrame, type: type)))
    }
    
    // MARK: IBAction
    
    @IBAction func createRectangle(_ sender: Any) {
        appendDefaultShape(.rectangle)
    }
    
    @IBAction func createEllipse(_ sender: Any) {
        appendDefaultShape(.ellipse)
    }
    @IBAction func createTraingle(_ sender: Any) {
        appendDefaultShape(.triangle)
    }
    @IBAction func deleteShape(_ sender: Any) {
        deleteSelectionShapes()
    }
    
}



extension CGRect {
    public init(rect: Rect) {
        self.init(x: rect.leftTop.x, y: rect.leftTop.y, width: rect.size.width, height: rect.size.hegiht)
    }
}
