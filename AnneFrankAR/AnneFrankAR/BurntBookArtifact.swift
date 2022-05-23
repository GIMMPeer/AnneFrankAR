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
    @IBOutlet weak var bookStack: UIStackView!
    
    @IBOutlet weak var bookText: UILabel!
    
    
  
    
    @IBAction func book1(_ sender: Any) {
        setupReading(bookNum: 1)
    }
    
    @IBAction func book2(_ sender: Any) {
        setupReading(bookNum: 2)
    }
    
    @IBAction func book3(_ sender: Any) {
        setupReading(bookNum: 3)

    }
    
    @IBAction func book4(_ sender: Any) {
        setupReading(bookNum: 4)
    }
    
    @IBAction func book5(_ sender: Any) {
        setupReading(bookNum: 5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay.isHidden = true
        bookStack.isHidden = true
        bookText.isHidden = true
        bookText.lineBreakMode = .byCharWrapping
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
                setupBook()
                
                
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
    
    func setupBook()
    {
        overlay.isHidden = false
        overlay.backgroundColor = .brown
        bookText.isHidden = true
        bookStack.isHidden = false
    }
    
    func setupReading(bookNum:Int32)
    {
        bookStack.isHidden = true
        bookText.isHidden = false
       if(bookNum == 1)
        {
           bookText.text = "The first panacea for a mismanaged nation is inflation of the currency; the second is war. Both bring a temporary prosperity; both bring a permanent ruin. But both are the refuge of political and economic opportunists. —Notes on the Next War, Esquire magazine, Ernest Hemingway, September 1935"
           bookText.sizeToFit()
           
           let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
               self.bookText.isHidden = true
               self.bookStack.isHidden = false
               
           }
       }
    }
}
