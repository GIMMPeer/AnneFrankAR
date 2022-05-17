//
//  MainMenu.swift
//  AnneFrankAR
//
//  Created by Admin on 5/16/22.
//

import UIKit
import SceneKit
import Foundation

class MainMenu: UIViewController
{
    var cameraNode: SCNNode!
    
   
    override func viewDidLoad(){
        super.viewDidLoad()
        //print("loaded")
        let scene = SCNScene(named: "art.scnassets/bookNoAnim.dae")!
        
        cameraNode = setupCamera(for: scene)
        setupLighting(for: scene)
        setupSceneView(with: scene, layer: 0, remove:false)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func setupCamera(for scene: SCNScene!) -> SCNNode {
            // Create and add a camera to the scene:
            let cameraNode = SCNNode()
            
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
            scene.rootNode.addChildNode(cameraNode)

            return cameraNode
        }
    
    func setupLighting(for scene: SCNScene!) {
           // Create and add a light to the scene:
           let lightNode = SCNNode()
           lightNode.light = SCNLight()
           lightNode.light!.type = .omni
           lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
           scene.rootNode.addChildNode(lightNode)
           
           // Create and add an ambient light to the scene:
           let ambientLightNode = SCNNode()
           ambientLightNode.light = SCNLight()
           ambientLightNode.light!.type = .ambient
           ambientLightNode.light!.color = UIColor.darkGray
           scene.rootNode.addChildNode(ambientLightNode)
       }
       
    func setupSceneView(with scene: SCNScene!, layer: Int, remove: Bool) {
           // in the SCNview
           let sceneView = SCNView(frame: view.frame)
           
           view.insertSubview(sceneView, at: layer)
           
           // set the scene to the view
           sceneView.scene = scene
           // allows the user to manipulate the camera
           //sceneView.allowsCameraControl = true
           
           // show statistics such as fps and timing information
           
           // configure the view
           sceneView.backgroundColor = UIColor.black
        
        if(remove == true)
        {
            let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                sceneView.removeFromSuperview()
                
            }
        }
           
       }
    
   
    @IBAction func TimelineAnimation(_ sender: Any) {
        let scene = SCNScene(named: "art.scnassets/book.dae")!
        
        setupSceneView(with: scene, layer:1, remove:true)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
            //print("Timer fired!")
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.navigationController?.pushViewController(loginVC, animated: false)
            
        }
        
        
    }
}

