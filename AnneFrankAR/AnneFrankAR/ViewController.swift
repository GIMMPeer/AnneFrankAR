//
//  ViewController.swift
//  AnneFrankAR
//
//  Created by Tri Nguyen on 3/4/22.
//

// :)

import UIKit
import RealityKit
import SceneKit
import ARKit
import CoreBluetooth


class ViewController: UIViewController, CBPeripheralDelegate, ARSessionDelegate {
    
    
    //@IBOutlet var arView: ARView!
    //Connection to the AR Scene View
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var menuButton: UIButton!
    
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
    @IBAction func unwindARView(_ sender:UIStoryboardSegue){}
    
    var canUseErase = false
    
    //Width and height of a node. To get the full width and height, multiply these by however many nodes there are going down and right. Change these to change the full width and height.
    let width = 0.06096
    let height = 0.04572
    
    //This is the 2D array where all arrays filled with nodes will go
    var arrScn = [[SCNNode]]()
    
    //Number of array generated is the same as the rows. Do 1 less than you want
    let numArrays = 59
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       cbCentralManager = CBCentralManager(delegate: self, queue: nil)
        

        //init things for scene
        //sceneView.delegate = self
        //show statistics shows framerate in corner, could probably be removed in future
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        
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
        
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
        //sceneView.addGestureRecognizer(UIPanGestureRecognizer()
        
        let configuration = ARWorldTrackingConfiguration()
        //Sets up detecting the vertical planes
        if #available(iOS 11.3, *) {
            configuration.planeDetection = .vertical
        }
        sceneView.session.run(configuration)
        
        sceneView.delegate = self
        
        setupGraffiti()
        //Adds in the pangesture, otherwise known as the erasing function
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
    }
    
    func setupGraffiti() {
        //Get rid of yellow dots by deleting this
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        configureLighting()
        
        //Creates the arrays to go into the main array
        for _ in 0...numArrays{
            let nodes = [SCNNode]()
            arrScn.append(nodes)
        }
                
    }
    
    //Configures lighting
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        //Only works after the plane is placed
        if(canUseErase == true){
            //Gets location of gesture
            let location = gesture.location(in: sceneView)
            
            //Uses location to see where the gesture hit
            guard let results = self.sceneView.hitTest(location, options: nil).first else { return }

            //The row and column of the node tapped is found here
            var y = 0
            var x = 0
            for i in  0...numArrays{
                for j in 0...numArrays{
                    if(arrScn[i][j].name == results.node.name){
                        y = i + 1
                        x = j + 1
                    }
                }
            }
            
            //Hides the node
            results.node.isHidden = true
            
            //Hides the node above it using the row and column as found above
            sceneView.scene.rootNode.childNode(withName: "row-\(y + 1)-column-\(x)", recursively: false)?.isHidden = true
            
            //Hides the node below it
            sceneView.scene.rootNode.childNode(withName: "row-\(y - 1)-column-\(x)", recursively: false)?.isHidden = true
            
            //Hides the node to the right
            sceneView.scene.rootNode.childNode(withName: "row-\(y)-column-\(x + 1)", recursively: false)?.isHidden = true
            
            //Hides the node to the left
            sceneView.scene.rootNode.childNode(withName: "row-\(y)-column-\(x - 1)", recursively: false)?.isHidden = true
        }
    }

    
    @objc func buttonAction(sender: UIButton!) {
        
      setupPortal(portalNum: 1)
    }
    
    @objc func buttonAction2(sender: UIButton!) {
      setupAnnex()
    }
    @objc func buttonAction3(sender: UIButton!)
    {
        setupChamber()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //sceneView.session.delegate = self             // ARSESSION DELEGATE
        //let configuration = ARWorldTrackingConfiguration()
        //sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let transform = frame.camera.transform
        let rotation = frame.camera.eulerAngles
        
        let position = transform.columns.3
        //print(position.x, position.y, position.z)
        // UPDATING
        camPos = SCNVector3(position.x, position.y, position.z)
        camRot = SCNVector3(rotation.x, rotation.y, rotation.z+1.5)
    
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

extension ViewController: ARSCNViewDelegate{
    //Hover over a wall then after a couple seconds, it will place it
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        print("Waiting")
        if canUseErase == false{
            
            //Columns and rows
            let rows = 60
            let columns = 60
            
            //Gets the anchor point where it will be placed
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            let y = CGFloat(planeAnchor.center.y)

            let base_z = y
            //Left to right. If you change the width or height, make sure to move it around so the full picture is centered on the screen
            let base_x = CGFloat(-1.7675)
            //Up and Down
            let base_y = CGFloat(0.88385)
            
            //Places all the planes
            for j in 1...rows{
                
                //Moves it down
                let moveY = base_y - (height * Double(j))
                
                for i in 1...columns{
                    //Moves it right
                    let moveX = base_x + (width * Double(i))
                    
                    //Sets up the plane
                    let pic2 = SCNPlane(width: width, height: height)
                    
                    //Makes the image into the plane
                    pic2.materials.first?.diffuse.contents = UIImage.init(named: "row-\(j)-column-\(i)")
                    
                    //Node for the picture
                    let p2N = SCNNode(geometry: pic2)
                    
                    //This is how you see if you hit the node above
                    p2N.name = "row-\(j)-column-\(i)"
                    
                    //Places the node next to the previous
                    p2N.position = SCNVector3(moveX, moveY, base_z)
                    
                    arrScn[j - 1].append(p2N)
                    //Adds to the scene
                    sceneView.scene.rootNode.addChildNode(p2N)
                }
            }
            
            //Can't place another one
            canUseErase = true
        }
    }
}
