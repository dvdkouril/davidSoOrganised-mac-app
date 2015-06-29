//
//  MasterViewController.swift
//  davidSoOrganised
//
//  Created by David Kouřil on 13/06/15.
//  Copyright (c) 2015 dvdkouril. All rights reserved.
//

import Cocoa
import SpriteKit

class MasterViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        

        if let scene = VisualizationScene.init(size: CGSize(width: 800, height: 300)) as? VisualizationScene {
            scene.size = self.view.bounds.size
            //println("scene.size = \(scene.size)")
            //println("self.view.bounds.size = \(self.view.bounds.size)")
            //scene.scaleMode = .AspectFill
            //scene.scaleMode = .AspectFit
            scene.backgroundColor = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
            
            (self.view as! SKView).presentScene(scene)
            //(self.view as! SKView).showsFPS = true
            //(self.view as! SKView).showsNodeCount = true
        }
    }
    
}
