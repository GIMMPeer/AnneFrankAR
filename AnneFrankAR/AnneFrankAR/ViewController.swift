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




class ViewController: UIViewController, CBPeripheralDelegate, ARSessionDelegate {
    
    
    @IBOutlet var arView: ARView!
    //Connection to the AR Scene View
    //@IBOutlet weak var sceneView: ARSCNView!
    
    
    
    @IBOutlet weak var menuButton: UIButton!
    
    /* Old Variables
    var tvPlayer:AVPlayer!
    var made = false;
    private var cbCentralManager: CBCentralManager!
    private var beacon: CBPeripheral!
    var one = -1
    var two = -1
    var three = -1
    var four = 0
    var nodeName:String?
    
    var camPos:SCNVector3?
    var camRot:SCNVector3?
     */
    @IBAction func unwindARView(_ sender:UIStoryboardSegue){
        let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        self.navigationController?.pushViewController(menu, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Central manager for beacons is not in use
       //cbCentralManager = CBCentralManager(delegate: self, queue: nil)
        
        //Old Scene View stuff
        /*
         
         sceneView.delegate = self
         //show statistics shows framerate in corner, could probably be removed in future
         sceneView.showsStatistics = true
         let scene = SCNScene()
         sceneView.scene = scene
         
         sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
         //sceneView.addGestureRecognizer(UIPanGestureRecognizer()
         */
        //init things for scene
        
        
        let menuImage = UIImage(named: "BookBlack")! as UIImage
        menuButton.setImage(menuImage, for: .normal)
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
          button.backgroundColor = .green
          button.setTitle("Propaganda", for: .normal)
          button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        let button_2 = UIButton(frame: CGRect(x: 100, y: 250, width: 100, height: 50))
          button_2.backgroundColor = .blue
          button_2.setTitle("Annex", for: .normal)
          button_2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        
        let button_3 = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
          button_3.backgroundColor = .red
          button_3.setTitle("Chamber", for: .normal)
          button_3.addTarget(self, action: #selector(buttonAction3), for: .touchUpInside)
        
        
        self.view.addSubview(button)
        self.view.addSubview(button_2)
        self.view.addSubview(button_3)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if
            ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        
        arView.environment.sceneUnderstanding.options = .occlusion
        

        let scene = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(scene)
         
        
    }
    

    //Need to convert these to Reality Kit try! load expereinces
    @objc func buttonAction(sender: UIButton!) {
        
      //setupPortal(portalNum: 1)
    }
    
    @objc func buttonAction2(sender: UIButton!) {
      //setupAnnex()
    }
    @objc func buttonAction3(sender: UIButton!)
    {
        //setupChamber()
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reality Kit Setup
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //arView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        //Old Scene Kit Setup
        //let transform = frame.camera.transform
        //let rotation = frame.camera.eulerAngles
        //let position = transform.columns.3
        //print(position.x, position.y, position.z)
        //camPos = SCNVector3(position.x, position.y, position.z)
        //camRot = SCNVector3(rotation.x, rotation.y, rotation.z+1.5)
    
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Interruption Ended, anchors may reset")
    }
    
    
}



//Not using beacons anymore
/*
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
        //print(made,one,two,three)
        if (one >= -75 && one != -1 && two >= -75 && two != -1 && three >= -75 && three != -1 && !made){
            made=true
            self.sceneView.showsStatistics = true
            let scene = SCNScene(named: "art.scnassets/ship.scn")!
            
            self.sceneView.scene = scene
            self.setupPortal(portalNum: 1)
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
*/

//Not using Gestures anymore, using reality kit
/*
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
            let bookArtifactScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BurntBookArtifact") as! BurntBookArtifact
            self.navigationController?.pushViewController(bookArtifactScene, animated: false)
        }
        else if(nodeName! == "blendShapesPoster")
        {
            let blendShapesPosterScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlendshapesPoster") as! BlendshapesPoster
            self.navigationController?.pushViewController(blendShapesPosterScene, animated: false)
        }
        if(nodeName! == "Paper")
        {
            let quizScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizController") as! QuizController
            self.navigationController?.pushViewController(quizScene, animated: false)
        }
        if(nodeName! == "Paper")
        {
            let quizScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizController") as! QuizController
            self.navigationController?.pushViewController(quizScene, animated: false)
        }
        if(nodeName! == "Cube")
        {
            let lessonScene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PropagandaLesson") as! PropagandaLesson
            self.navigationController?.pushViewController(lessonScene, animated: false)
        }
    }else{
        print("nil")
    }
}
 */

//Old Scene Kit way of doing things
/*
func setupPortal(portalNum: Int) {
    //**Rendering order must be above 100 in order to be properly hidden in the portal
    
    //node is the spawn point of everything in the scene
    let node = SCNNode()
    
    
    node.position = camPos!
    node.eulerAngles = camRot!
    
    // broke some of the code out to another function
    buildRoom(num: portalNum, node: node)
    
    if(portalNum == 1) {
        
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource:"videoplayback", ofType: "mp4")!)
        tvPlayer = AVPlayer(url: fileURL)
        
        // add video to plane
        let tvGeo = SCNPlane(width:1.6,height: 0.9)
        tvGeo.firstMaterial?.diffuse.contents = tvPlayer
        tvGeo.firstMaterial?.isDoubleSided = true
        
        // create node containing plane
        let tvNode = SCNNode(geometry: tvGeo)
        tvNode.position.z = -0.9
        
        // play video
        node.addChildNode(tvNode)
        tvPlayer.play()
        
        // add subscene stuff
        let subScene = SCNScene(named: "art.scnassets/Scenes/PropagandaScene.scn")!
        
        // more subscene stuff
        let quiz = subScene.rootNode.childNode(withName: "TextualRhetoric", recursively: true)!
        quiz.position = SCNVector3.init(0.50, -0.5, -0.75)
        quiz.eulerAngles = SCNVector3.init(0, 0, 0)
        
        // subscene subscene subscene
        let propagandaLesson = subScene.rootNode.childNode(withName: "cubeydude", recursively: true)!
        propagandaLesson.position = SCNVector3.init(-0.50, -0.5, -0.75)
        
        let germ = subScene.rootNode.childNode(withName: "Cylinder2", recursively: true)!
        germ.position = SCNVector3.init(-0.75, -0.1, (-length / 2) + width * 3)
        germ.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        let germ_2 = subScene.rootNode.childNode(withName: "Cylinder2_2", recursively: true)!
        germ_2.position = SCNVector3.init(0.75, -0.1, (-length / 2) + width * 3)
        germ_2.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)
        
        // <b>s t a n</b>
        let person = subScene.rootNode.childNode(withName: "stan", recursively: true)!
        person.position = SCNVector3.init(0, -0.95, -0.75)
        person.eulerAngles = SCNVector3.init(0, Double.pi / 16, 0)
        
        // addng the burnt book
        let burntBook = subScene.rootNode.childNode(withName: "BurntBook reference", recursively: true)!
        burntBook.position = SCNVector3.init(0.30, -0.5, -0.75)
        burntBook.eulerAngles = SCNVector3.init(0, 0, 0)
        
        let bsPoster = subScene.rootNode.childNode(withName: "blendShapesPoster", recursively: true)!
        bsPoster.position = SCNVector3.init(0.90, 0, (length / 10) + width * 2)
        bsPoster.eulerAngles = SCNVector3.init(0, Double.pi / 2, 0)
        
        // add nodes to scene
        node.addChildNode(propagandaLesson)
        node.addChildNode(quiz)
        node.addChildNode(person)
        node.addChildNode(germ)
        node.addChildNode(germ_2)
        node.addChildNode(burntBook)
        node.addChildNode(bsPoster)
    }
    
    //This is the final step, officially adding node to the scene itself
    self.sceneView.scene.rootNode.addChildNode(node)
}

func setupAnnex()
{
    let node = SCNNode()
    
    node.position = camPos!
    node.eulerAngles = camRot!
    
    let scene = SCNScene(named: "art.scnassets/Scenes/AnneFrankAnnex.scn")!
    
    node.addChildNode(scene.rootNode)
    
    self.sceneView.scene.rootNode.addChildNode(node)
    
}
func setupChamber()
{
    let node = SCNNode()
    
    node.position = camPos!
    node.eulerAngles = SCNVector3(x:Float(Double.pi) / 2, y:0, z:0)
    node.scale = SCNVector3(x:0.1, y:0.1, z:0.1)
    
    let scene = SCNScene(named: "art.scnassets/Scenes/Chamber.scn")!
    
    node.addChildNode(scene.rootNode)
    
    self.sceneView.scene.rootNode.addChildNode(node)
}

      */
 
 */
