//
//  GameViewController.swift
//  MyGameIOS
//
//  Created by user196253 on 4/29/22.
//

import UIKit
import SpriteKit

class GameViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
}
