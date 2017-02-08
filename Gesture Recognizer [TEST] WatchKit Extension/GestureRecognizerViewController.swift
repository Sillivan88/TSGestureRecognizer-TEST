//
//  GestureRecognizerViewController.swift
//  Gesture Recognizer [TEST]
//
//  Created by Thomas Sillmann on 08.02.17.
//  Copyright © 2017 Thomas Sillmann. All rights reserved.
//

import WatchKit
import SpriteKit

class GestureRecognizerViewController: WKInterfaceController {
    
    // MARK: - Properties
    
    @IBOutlet var gestureSceneInterface: WKInterfaceSKScene!
    
    @IBOutlet var swipeSceneInterface: WKInterfaceSKScene!
    
    lazy var gestureScene: SKScene = {
        let gestureScene = SKScene(size: WKInterfaceDevice.current().screenBounds.size)
        gestureScene.addChild(self.gestureLabel)
        gestureScene.backgroundColor = .darkGray
        return gestureScene
    }()
    
    lazy var swipeScene: SKScene = {
        let swipeScene = SKScene(size: WKInterfaceDevice.current().screenBounds.size)
        swipeScene.addChild(self.swipeLabel)
        swipeScene.backgroundColor = .darkGray
        return swipeScene
    }()
    
    lazy var gestureLabel: SKLabelNode = {
        let gestureLabel = SKLabelNode(text: "Use gesture")
        gestureLabel.fontSize = 24
        gestureLabel.position = CGPoint(x: WKInterfaceDevice.current().screenBounds.size.width / 2, y: WKInterfaceDevice.current().screenBounds.size.height / 2)
        return gestureLabel
    }()
    
    lazy var swipeLabel: SKLabelNode = {
        let swipeLabel = SKLabelNode(text: "Swipe!")
        swipeLabel.fontSize = 24
        swipeLabel.position = CGPoint(x: WKInterfaceDevice.current().screenBounds.size.width / 2, y: WKInterfaceDevice.current().screenBounds.size.height / 2)
        return swipeLabel
    }()
    
    // MARK: - Methods
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        gestureSceneInterface.presentScene(gestureScene)
        swipeSceneInterface.presentScene(swipeScene)
    }
    
    // MARK: Gesture shape node
    
    private func shapeNodeForGestureRecognizer(_ gestureRecognizer: WKGestureRecognizer, fillColor: UIColor) -> SKShapeNode {
        let shapeNode = SKShapeNode(rectOf: CGSize(width: 44, height: 44), cornerRadius: 44)
        shapeNode.fillColor = fillColor
        shapeNode.position = CGPoint(x: gestureRecognizer.locationInObject().x, y: WKInterfaceDevice.current().screenBounds.size.height - gestureRecognizer.locationInObject().y)
        return shapeNode
    }
    
    private func showShapeNodeAction() -> SKAction {
        return SKAction.fadeIn(withDuration: 0.5)
    }
    
    private func hideAndRemoveShapeNodeAction() -> SKAction {
        let hideShapeNodeAction = SKAction.fadeOut(withDuration: 0.5)
        let removeShapeNodeAction = SKAction.removeFromParent()
        return SKAction.sequence([hideShapeNodeAction, removeShapeNodeAction])
    }
    
    private func combinedShowHideAndRemoveShapeNodeAction() -> SKAction {
        return SKAction.sequence([showShapeNodeAction(), hideAndRemoveShapeNodeAction()])
    }
    
    private func executeShapeNodeOnScene(_ shapeNode: SKShapeNode) {
        gestureScene.addChild(shapeNode)
        shapeNode.run(combinedShowHideAndRemoveShapeNodeAction())
    }
    
    // MARK: Handle gesture recognizer
    
    @IBAction func handleGesture(gestureRecognizer: WKGestureRecognizer) {
        removeGestureLabelIfVisible()
        if let tapGestureRecognizer = gestureRecognizer as? WKTapGestureRecognizer {
            handleTapGestureRecognizer(tapGestureRecognizer)
        } else if let swipeGestureRecognizer = gestureRecognizer as? WKSwipeGestureRecognizer {
            handleSwipeGestureRecognizer(swipeGestureRecognizer)
        } else if let longPressGestureRecognizer = gestureRecognizer as? WKLongPressGestureRecognizer {
            handleLongPressGestureRecognizer(longPressGestureRecognizer)
        } else if let panGestureRecognizer = gestureRecognizer as? WKPanGestureRecognizer {
            handlePanGestureRecognizer(panGestureRecognizer)
        }
    }
    
    private func handleTapGestureRecognizer(_ tapGestureRecognizer: WKTapGestureRecognizer) {
        setTitle("Tap")
        let tapShapeNode = shapeNodeForGestureRecognizer(tapGestureRecognizer, fillColor: .blue)
        executeShapeNodeOnScene(tapShapeNode)
    }
    
    private func handleSwipeGestureRecognizer(_ swipeGestureRecognizer: WKSwipeGestureRecognizer) {
        setTitle("Swipe")
        if swipeGestureRecognizer.direction == .left {
            swipeLabel.text = "Left"
        } else if swipeGestureRecognizer.direction == .right {
            swipeLabel.text = "Right"
        }
    }
    
    private func handleLongPressGestureRecognizer(_ longPressGestureRecognizer: WKLongPressGestureRecognizer) {
        setTitle("Long Press")
        if longPressGestureRecognizer.state == .began {
            gestureScene.run(SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 0.5))
        } else if longPressGestureRecognizer.state == .ended || longPressGestureRecognizer.state == .cancelled {
            let colorizeRedAction = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 1)
            let colorizeClearAction = SKAction.colorize(with: .darkGray, colorBlendFactor: 1, duration: 0.5)
            gestureScene.run(SKAction.sequence([colorizeRedAction, colorizeClearAction]))
        }
    }
    
    private func handlePanGestureRecognizer(_ panGestureRecognizer: WKPanGestureRecognizer) {
        setTitle("Pan")
        var panShapeNode: SKShapeNode!
        if panGestureRecognizer.state == .began {
            panShapeNode = shapeNodeForGestureRecognizer(panGestureRecognizer, fillColor: .green)
        } else if panGestureRecognizer.state == .changed {
            panShapeNode = shapeNodeForGestureRecognizer(panGestureRecognizer, fillColor: .yellow)
        } else if panGestureRecognizer.state == .ended || panGestureRecognizer.state == .cancelled {
            panShapeNode = shapeNodeForGestureRecognizer(panGestureRecognizer, fillColor: .red)
        }
        executeShapeNodeOnScene(panShapeNode)
    }
    
    private func removeGestureLabelIfVisible() {
        if gestureLabel.scene == gestureScene {
            gestureLabel.removeFromParent()
        }
    }
    
}
