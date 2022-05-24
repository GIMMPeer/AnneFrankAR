//
//  BlendshapesPoster.swift
//  AnneFrankAR
//
//  Created by Aaron Easter on 4/1/22.
//

import UIKit
import Foundation
import SceneKit
import ARKit

class BlendshapesPoster: UIViewController {
    
    @IBOutlet var faceView: SCNView!
    
    @IBOutlet var trackingView: ARSCNView!
    
    var contentNode: SCNReferenceNode? // Reference to the .scn file

    var cameraPosition = SCNVector3Make(0, 15, 70) // Camera node to set position that the SceneKit is looking at the character

    let scene = SCNScene()

    let cameraNode = SCNNode()
    
    //private lazy var model = contentNode!.childNode(withName: "model", recursively: true)! // Whole model including eyes

    private lazy var poster = contentNode!.childNode(withName: "Poster", recursively: true)! // Face that contains blendshapes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVCaptureDevice.requestAccess(for: AVMediaType.video){
            granted in if (granted){
                // If access is granted, setup the main view
                DispatchQueue.main.sync{
                    self.setupFaceTracker()
                    self.sceneSetup()
                    self.createCameraNode()
                }
            } else {
                    // If access is not granted, throw error and exit
                    fatalError("This app needs Camera Access to function. You can grant access in Settings.")
                }
            }
        }
    
    func setupFaceTracker(){
        // Configure and start face tracking session
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        // Run ARSession and set delegate to self
        self.trackingView.session.run(configuration)
        self.trackingView.delegate = self
        //self.trackingView.isHidden = true // Remove if you want to see the camera feed
    }
    
    func sceneSetup(){
        if let filePath = Bundle.main.path(forResource: "Blendshapes Poster_draft", ofType: "scn", inDirectory: "art.scnassets"){
            let referenceURL = URL(fileURLWithPath: filePath)
            self.contentNode = SCNReferenceNode(url: referenceURL)
            self.contentNode?.load()
            
            self.poster.morpher?.unifiesNormals = true // ensures normals are not morphed, but are recomputed after morphing vertex instead. Otherwise the node has a low poly look
            self.scene.rootNode.addChildNode(self.contentNode!)
        }
        self.faceView.autoenablesDefaultLighting = true
        
        // Set the sene to the view
        self.faceView.scene = self.scene
        
        // Allows the user to manipulate the camera
        self.faceView.allowsCameraControl = false
        
        self.faceView.backgroundColor = .white
        
        //self.model.morpher?.unifiesNormals = true // if there's an issue with the model being low-poly when it should be smooth-shaded, this line of code will help fix that
    }
    
    func createCameraNode(){
        self.cameraNode.camera = SCNCamera()
        self.cameraNode.position = self.cameraPosition
        self.scene.rootNode.addChildNode(self.cameraNode)
        self.faceView.pointOfView = self.cameraNode
    }
}

extension BlendshapesPoster: ARSCNViewDelegate {
    //this method is called each frame while the scene is being rendered
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor
        else {return}
        
        DispatchQueue.main.async {
            let blendShapes = faceAnchor.blendShapes
            
            // This will only work correctly if the shape keys are given the exact same name as the blendshape names
            for (key, value) in blendShapes {
                if let fValue = value as? Float{

                    self.poster.morpher?.setWeight(CGFloat(fValue), forTargetNamed: key.rawValue)
                }
            }
        }
    }
}
