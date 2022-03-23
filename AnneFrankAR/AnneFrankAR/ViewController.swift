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
import CoreBluetooth

class ViewController: UIViewController, ARSCNViewDelegate, CBPeripheralDelegate {
    
    
    //@IBOutlet var arView: ARView!
    @IBOutlet weak var sceneView: ARSCNView!
    var made = false;
    private var cbCentralManager: CBCentralManager!
    private var beacon: CBPeripheral!
    var one = -1
    var two = -1
    var three = -1
    override func viewDidLoad() {
        super.viewDidLoad()
       cbCentralManager = CBCentralManager(delegate: self, queue: nil)
        
//        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! PosterInteractiveExample.loadBox()
//
//        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
 
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
        let node = SCNNode()
       //
        
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
        
        let posterTest = createPoster(image: "art.scnassets/Poster_Base_AR.png")
        posterTest.position = SCNVector3.init(0, 0, (-length / 2) + width * 2)
        posterTest.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)
        
        let subScene = SCNScene(named: "art.scnassets/AmericanPillar.scn")!
        let amer = subScene.rootNode.childNode(withName: "Cylinder", recursively: true)!
        amer.position = SCNVector3.init(0.75, -0.1, (-length / 2) + width * 3)
        amer.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        let germ = subScene.rootNode.childNode(withName: "Cylinder2", recursively: true)!
        germ.position = SCNVector3.init(-0.75, -0.1, (-length / 2) + width * 3)
        germ.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        //create light
        let light = SCNLight()
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
        let constraint = SCNLookAtConstraint(target: bottomWall)
        constraint.isGimbalLockEnabled = true
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3.init(0, 4, 0)
        lightNode.constraints = [constraint]
        node.addChildNode(lightNode)
        
        node.addChildNode(leftWall)
        node.addChildNode(rightWall)
        node.addChildNode(topWall)
        node.addChildNode(bottomWall)
        node.addChildNode(backWall)
        node.addChildNode(leftDoorSide)
        node.addChildNode(rightDoorSide)
        let pov = self.sceneView.pointOfView
        let position = pov?.position
        let angle = pov?.eulerAngles
        let posx = position?.x
        let posy = position?.y
        let posz = position?.z
        let angx = angle?.x
        let angy = angle?.y
        let angz = angle?.z
        print(angx,angy,angz)
        node.position = SCNVector3(x: posx!, y: posy!, z: posz!-2)
        node.eulerAngles=SCNVector3.init(0,0, 0)
        //self.sceneView.pointOfView?.addChildNode(node)
        node.addChildNode(posterTest)
        node.addChildNode(amer)
        node.addChildNode(germ)

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

extension ViewController :  CBCentralManagerDelegate {

    
    
func centralManagerDidUpdateState(_ central: CBCentralManager) {
 if central.state == .poweredOn {
     DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
        // Code you want to be delayed
         central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
         print("Scanning...")
     }

  }
}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
          //discover all service
          print("connected")
          peripheral.discoverServices(nil)
          
                   }
        
         
      guard peripheral.name != nil else {return}

        //print(peripheral.name)
        //print(RSSI)
        //print(peripheral.name)
        if(peripheral.name=="Beacon_1"){
            one=Int(RSSI)
            //print(advertisementData)

            
            //cbCentralManager?.connect(beacon!, options: nil)
        }

        if(peripheral.name=="Beacon_2"){
            two=Int(RSSI)
            //print(advertisementData)
            
            //cbCentralManager?.connect(beacon!, options: nil)
        }

        if(peripheral.name=="Beacon_3"){
            three=Int(RSSI)
            //print(advertisementData)
      
            
            //cbCentralManager?.connect(beacon!, options: nil)
        }
        print(made,one,two,three)
        if (one >= -75 && one != -1 && two >= -75 && two != -1 && three >= -75 && three != -1 && !made){
            made=true
            self.sceneView.showsStatistics = true
            let scene = SCNScene(named: "art.scnassets/ship.scn")!
            
            self.sceneView.scene = scene
            self.setupScene()
        }

      

    }
    func disconnectFromDevice () {
        if beacon != nil {
        cbCentralManager?.cancelPeripheralConnection(beacon!)
        }
     }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        print(beacon)
        print(beacon.readRSSI())
  
        
        
}
}
