//
//  BurntBookArtifact.swift
//  AnneFrankAR
//
//  Created by Admin on 5/19/22.
//

import Foundation
import UIKit
import SceneKit

class BurntBookArtifact: UIViewController, SCNSceneRendererDelegate
{
    var nodeName:String?
    
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var overlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay.alpha = 0
        
        sceneView.delegate = self
        //show statistics shows framerate in corner, could probably be removed in future
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        setupGame()
        
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
    }
    
    @objc func handleTap(_ gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: self.sceneView)
        guard let nodeHitTest = self.sceneView.hitTest(location, options: nil).first else{
            print("no node"); return
        }
        let nodeHit = nodeHitTest.node
        nodeName = nodeHit.name
        if(nodeName != nil){
            print(nodeName!)
            
            if(nodeName! == "Book")
            {
                overlay.alpha = 1
                overlay.backgroundColor = .brown
                
            }
        }else{
            print("nil")
        }
    }
    
    
    func setupGame()
    {
        let node = SCNNode()
        
        let bonfireScene = SCNScene(named: "art.scnassets/bonfire.scn")!

        node.addChildNode(bonfireScene.rootNode)
        
        let light = SCNLight()
        //omni has worked the best on image textures, but could be better
        light.type = .omni
        light.spotInnerAngle = 70
        light.spotOuterAngle = 120
        light.zNear = 0.00001
        light.zFar = 3
        light.castsShadow = true
        light.shadowRadius = 200
        light.intensity = 400
        light.shadowColor = UIColor.black.withAlphaComponent(0.7)
        light.shadowMode = .forward
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3.init(0, 4, 0)
        node.addChildNode(lightNode)
        
        self.sceneView.scene!.rootNode.addChildNode(node)
        
    }
}
