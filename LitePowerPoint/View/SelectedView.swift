//
//  SelectedView.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 23.01.2021.
//

import Foundation
import UIKit

class SelectedView: UIView {
    @IBOutlet var leftTop: UIImageView!
    @IBOutlet var leftBottom: UIImageView!
    @IBOutlet var rightTop: UIImageView!
    @IBOutlet var rightBottom: UIImageView!
    
    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, none
    }

    static var edgeSize: CGFloat = 12.0
    private typealias Item = SelectedView
    
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    
    var doOnChangeFrame: DoOnChangeFrameHandler?
    var removeSelection: RemoveSelectionHandler?
    private var shapeId: String?
    private var selfFrame: Rect {
        get {
            Rect(leftTop: .init(x: Double(self.frame.minX), y: Double(self.frame.minY)), size: .init(width: Double(self.frame.width), hegiht: Double(self.frame.height)))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBorder()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeSelection(sender:))))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setShapeId(_ id: String) {
        self.shapeId = id
    }
    
    func getShapeId() -> String {
        self.shapeId ?? ""
    }
    
    
    private func setBorder() {
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc private func removeSelection(sender: UITapGestureRecognizer) {
        removeSelection?()
    }
}


extension SelectedView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {

            touchStart = touch.location(in: self)

            currentEdge = {
                if self.bounds.size.width - touchStart.x < Item.edgeSize && self.bounds.size.height - touchStart.y < Item.edgeSize {
                    return .bottomRight
                } else if touchStart.x < Item.edgeSize && touchStart.y < Item.edgeSize {
                    return .topLeft
                } else if self.bounds.size.width-touchStart.x < Item.edgeSize && touchStart.y < Item.edgeSize {
                    return .topRight
                } else if touchStart.x < Item.edgeSize && self.bounds.size.height - touchStart.y < Item.edgeSize {
                    return .bottomLeft
                }
                return .none
            }()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)

            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height

            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y

            switch currentEdge {
            case .topLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
            case .topRight:
                self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
            case .bottomRight:
                self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaHeight)
            case .bottomLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
            default:
                // Moving
                self.center = CGPoint(x: self.center.x + currentPoint.x - touchStart.x,
                                      y: self.center.y + currentPoint.y - touchStart.y)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentEdge = .none
        doOnChangeFrame?(selfFrame)
    }
}
