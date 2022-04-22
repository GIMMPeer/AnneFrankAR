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
    //Connection to the AR Scene View
    @IBOutlet weak var sceneView: ARSCNView!
    
    var made = false;
    private var cbCentralManager: CBCentralManager!
    private var beacon: CBPeripheral!
    var one = -1
    var two = -1
    var three = -1
    var currentPage = 0;
    var currentTimeLine:UIButton!
    
    //Decleare Instances
    var buttonList = [UIButton:[PageItem]]()
    var contentData: ContentData?
    @IBOutlet weak var HorizonalStackButtons: UIStackView!
    @IBOutlet weak var ContentUI: UIView!
    @IBOutlet weak var ButtonUIView: UIView!
    @IBOutlet weak var ContentTitleUI: UILabel!
    
    @IBOutlet weak var ContentTextUI: UILabel!
    
    @IBOutlet weak var ContentPageUI: UILabel!
    @IBOutlet weak var ToPrevPageUI: UIView!
    @IBOutlet weak var ToNextPageUI: UIView!
    @IBAction func ToNextScenes(unwindSegue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       cbCentralManager = CBCentralManager(delegate: self, queue: nil)
        

        //init things for scene
        sceneView.delegate = self
        //show statistics shows framerate in corner, could probably be removed in future
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        //setupScene is the function that builds the AR portal
        setupScene()
        parseJson()
        setUpUI()
        
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
       //
        
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
        let pov = self.sceneView.pointOfView
        let position = pov?.position
        let angle = pov?.eulerAngles
        let posx = position?.x
        let posy = position?.y
        let posz = position?.z
        let angx = angle?.x
        let angy = angle?.y
        let angz = angle?.z
        
        node.position = SCNVector3(x: posx!, y: posy!, z: posz!-2)
        node.eulerAngles=SCNVector3.init(0,0, 0)
        //self.sceneView.pointOfView?.addChildNode(node)
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
    
    func parseJson(){
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else{
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do{
            let jsonData = try Data(contentsOf: url)
            contentData = try JSONDecoder().decode(ContentData.self, from: jsonData)
        }catch{
            print("Error: \(error)")
        }
    }
    
//    private func getTotalContents() -> Int{
//        return contentData!.data.count ?? 0
//    }
    
    func setUpUI(){
        if contentData != nil{
            let contentList = contentData!.data
            for contentItem in contentList{
                let button = UIButton(type: .system)
                let title:String = contentItem.title
                button.setTitle("\(title)", for: .normal)
                button.setImage(UIImage(named: "circle"), for: .normal)
                button.setImage(UIImage(named: "circle.fill"), for: .selected)

                button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                HorizonalStackButtons.alignment = .center
                HorizonalStackButtons.distribution = .fillEqually
                HorizonalStackButtons.spacing = 80
                HorizonalStackButtons.addArrangedSubview(button)
                buttonList[button] = contentItem.pageData

            }
        }

    }
    
    @IBAction func buttonAction(_ sender:UIButton){
        currentTimeLine = sender
        currentPage = 0
        if (sender.isSelected == true){
            ContentUI.isHidden = true;
            sender.isSelected = false
        }
        else{
            ContentUI.isHidden = false;
            sender.isSelected = true
        }
        
        for (btn,pageItem) in buttonList{
            if(btn != sender){
                btn.isSelected = false
            } else{
                
                var pageIndex = currentPage%pageItem.count
                ContentTitleUI.text = pageItem[pageIndex].title
                ContentTextUI.text = pageItem[pageIndex].context
                ContentPageUI.text = "Page \(pageIndex+1) of \(pageItem.count)"
            }
            
        }
        
        
        
        ButtonUIView.alpha = 1
    }
    
    func UpdateContentPage(){
        var pageItem = buttonList[currentTimeLine]!
        if pageItem != nil{
            var pageIndex = currentPage%pageItem.count
            ContentTitleUI.text = pageItem[pageIndex].title
            ContentTextUI.text = pageItem[pageIndex].context
            ContentPageUI.text = "Page \(pageIndex+1) of \(pageItem.count)"
        }
   
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch:UITouch? = touches.first
        if(touch?.view == sceneView){
            ContentUI.isHidden = true
            ButtonUIView.alpha = 0.5
            for (btn,pageItem) in buttonList{
                btn.isSelected = false
            }
        } else{
            ButtonUIView.alpha = 1
        }
        
        if(touch?.view == ToPrevPageUI){
            currentPage -= 1
            UpdateContentPage()
        }
        if(touch?.view == ToNextPageUI){
            currentPage += 1
            UpdateContentPage()
        }
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
