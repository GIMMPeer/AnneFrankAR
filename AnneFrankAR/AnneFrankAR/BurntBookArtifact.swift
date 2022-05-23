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
    
    @IBOutlet weak var bookButton1: UIButton!
    
    @IBOutlet weak var bookButton2: UIButton!
    
    @IBOutlet weak var bookButton3: UIButton!
    
    @IBOutlet weak var bookButton4: UIButton!
    
    @IBOutlet weak var bookButton5: UIButton!
    
    @IBAction func book1(_ sender: Any) {
        setupReading(bookNum: 1)
        bookButton1.isHidden = true
    }
    
    @IBAction func book2(_ sender: Any) {
        setupReading(bookNum: 2)
        bookButton2.isHidden = true
    }
    
    @IBAction func book3(_ sender: Any) {
        setupReading(bookNum: 3)
        bookButton3.isHidden = true

    }
    
    @IBAction func book4(_ sender: Any) {
        setupReading(bookNum: 4)
        bookButton4.isHidden = true
    }
    
    @IBAction func book5(_ sender: Any) {
        setupReading(bookNum: 5)
        bookButton5.isHidden = true
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
           
           
           
               
           }
        if(bookNum == 2)
        {
            bookText.text = "I am young, I am twenty years old; yet I know nothing of life but despair, death, fear, and fatuous superficiality cast over an abyss of sorrow. I see how peoples are set against one another, and in silence, unknowingly, foolishly, obediently, innocently slay one another."
            
        }
        if(bookNum == 3)
        {
            bookText.text = "We will grind you revolutionists down under our heel, and we shall walk upon your faces. The world is ours, we are its lords, and ours it shall remain. As for the host of labor, it has been in the dirt since history began, and I read history aright. And in the dirt it shall remain so long as I and mine and those that come after us have the power. There is the word. It is the king of words—Power. Not God, not Mammon, but Power. Pour it over your tongue till it tingles with it. Power."
        }
        if(bookNum == 4)
        {
            bookText.text = "Is it not astonishing that, in the course of history, all human types except [the soulful human who possesses fantasy] have been in power?...Instead of expecting such a person to come along, we must expect gas warfare! And the culprit will be the philistine nature of the political and economical world powers. Everything evil or stupid in this world is not supernatural destiny, but rather a deadly form of lack of fantasy..."
        }
        if(bookNum == 5)
        {
            bookText.text = "But one who understands will not judge, and will have no pride. Before him I shall not be ashamed. Whoever has found himself can never again lose anything in this world. He who has grasped the human in himself understands all mankind."
        }
        
        bookText.numberOfLines = 5
        bookText.sizeToFit()
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            self.bookText.isHidden = true
            self.bookStack.isHidden = false
       }
    }
}
