//
//  GameViewController.swift
//  MyFirstGame
//
//  Created by Zachary Vargas on 4/2/16.
//  Copyright (c) 2016 Zach Vargas. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    private var scene:GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        scene = GameScene(size: view.bounds.size)
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.ResizeFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
            skView.presentScene(scene)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
