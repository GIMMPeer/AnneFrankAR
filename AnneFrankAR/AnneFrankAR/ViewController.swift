//
//  ViewController.swift
//  AnneFrankAR
//
//  Created by Tri Nguyen on 3/4/22.
//

import UIKit
import RealityKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //@IBOutlet var arView: ARView!
    //Connection to the AR Scene View
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init things for scene
        sceneView.delegate = self
        //show statistics shows framerate in corner, could probably be removed in future
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        //setupScene is the function that builds the AR portal
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupScene() {
        //**Rendering order must be above 100 in order to be properly hidden in the portal
        
        //node is the spawn point of everything in the scene
        let node = SCNNode()
        node.position = SCNVector3.init(0, 0, 0)
        
        //each wall calls createBox() which is in Extensions
        let leftWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Wall_1.png")
        leftWall.position = SCNVector3.init((-length / 2) + width, 0, 0)
        leftWall.eulerAngles = SCNVector3.init(0, 180.0.degreesToRadians, 0)
        
        let rightWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Wall_1.png")
        rightWall.position = SCNVector3.init((length / 2) - width, 0, 0)
        
        let topWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Floor.png")
        topWall.position = SCNVector3.init(0, (height / 2) - width, 0)
        topWall.eulerAngles = SCNVector3.init(0, 0, 90.0.degreesToRadians)
        
        let bottomWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Floor.png")
        bottomWall.position = SCNVector3.init(0, (-height / 2) + width, 0)
        bottomWall.eulerAngles = SCNVector3.init(0, 0, -90.0.degreesToRadians)
        
        let backWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Wall_1.png")
        backWall.position = SCNVector3.init(0, 0, (-length / 2) + width)
        backWall.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)
        
        let leftDoorSide = createBox(isDoor: true, img: "art.scnassets/Wall Textures/Floor.png")
        leftDoorSide.position = SCNVector3.init((-length / 2 + width) + (doorLength / 2), 0, (length / 2) - width)
        leftDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        let rightDoorSide = createBox(isDoor: true, img: "art.scnassets/Wall Textures/Floor.png")
        rightDoorSide.position = SCNVector3.init((length / 2 - width) - (doorLength / 2), 0, (length / 2) - width)
        rightDoorSide.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        //This is not a wall, it's a poster. Works very similar to the walls though
        //createPoster() is also in Extensions
        let posterTest = createPoster(image: "art.scnassets/Poster_Base_AR.png")
        posterTest.position = SCNVector3.init(0, 0, (-length / 2) + width * 2)
        posterTest.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)
        
        //This is accessing the AmericanPillar.scn file which has 2 pillar objects in it
        let subScene = SCNScene(named: "art.scnassets/AmericanPillar.scn")!
        
        //This is accessing the scn file and then the specific pillar object called "Cylinder"
        let amer = subScene.rootNode.childNode(withName: "Cylinder", recursively: true)!
        amer.position = SCNVector3.init(0.75, -0.1, (-length / 2) + width * 3)
        amer.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        //This is accessing the scn file and then the specific pillar object called "Cylinder2"
        let germ = subScene.rootNode.childNode(withName: "Cylinder2", recursively: true)!
        germ.position = SCNVector3.init(-0.75, -0.1, (-length / 2) + width * 3)
        germ.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)

        
        //create light, otherwise the portal would be black
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
        //This points the light in a specific direction
        let constraint = SCNLookAtConstraint(target: bottomWall)
        constraint.isGimbalLockEnabled = true
        
        //This is what actually places the light in the scene
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3.init(0, 4, 0)
        lightNode.constraints = [constraint]
        node.addChildNode(lightNode)
        
        //node is the main scene node in the center of the scene
        //If you add something and it's not showing up in the scene, chances are you need to add it to node
        node.addChildNode(leftWall)
        node.addChildNode(rightWall)
        node.addChildNode(topWall)
        node.addChildNode(bottomWall)
        node.addChildNode(backWall)
        node.addChildNode(leftDoorSide)
        node.addChildNode(rightDoorSide)
        posterTest.renderingOrder=200
        
        node.addChildNode(posterTest)
        node.addChildNode(amer)
        node.addChildNode(germ)
        
        //This is the final step, officially adding node to the scene itself
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
