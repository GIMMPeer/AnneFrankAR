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
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sceneView.delegate = self
        //show statistics shows framerate in corner, could probably be removed in future
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        setupGame()
        
    }
    
    func setupGame()
    {
        let node = SCNNode()
        
        let bonfireScene = SCNScene(named: "art.scnassets/bonfire.scn")!
        
        let book1 = bonfireScene.rootNode.childNode(withName: "Book1", recursively: true)!
        let book2 = bonfireScene.rootNode.childNode(withName: "Book2", recursively: true)!
        let book3 = bonfireScene.rootNode.childNode(withName: "Book2", recursively: true)!

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
