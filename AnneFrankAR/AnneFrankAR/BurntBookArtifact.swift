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
    
    var index:Int32 = 0
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var bookStack: UIStackView!
    
    @IBOutlet weak var bookText: UILabel!
    
    @IBOutlet weak var bookButton1: UIButton!
    
    @IBOutlet weak var bookButton2: UIButton!
    
    @IBOutlet weak var bookButton3: UIButton!
    
    @IBOutlet weak var bookButton4: UIButton!
    
    @IBOutlet weak var bookButton5: UIButton!
    
    @IBOutlet weak var backgroundTexture: UIImageView!
    
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
        backgroundTexture.isHidden = true
        bookStack.isHidden = true
        bookText.isHidden = true
        //bookText.lineBreakMode = .byCharWrapping
        sceneView.delegate = self
        
        
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
        
        let bonfireScene = SCNScene(named: "art.scnassets/BookBurning/bonfire.scn")!

        node.addChildNode(bonfireScene.rootNode)
        
       
        self.sceneView.scene!.rootNode.addChildNode(node)
        
    }
    
    func setupBook()
    {
        bookStack.isHidden = false
        backgroundTexture.isHidden = false
        bookText.isHidden = true
        
    }
    
    func setupReading(bookNum:Int32)
    {
        
        
        bookStack.isHidden = true
        bookText.isHidden = false
       if(bookNum == 1)
        {
           bookText.text = "The first panacea for a mismanaged nation is inflation of the currency; the second is war. Both bring a temporary prosperity; both bring a permanent ruin. But both are the refuge of political and economic opportunists. —Notes on the Next War, Esquire magazine, Ernest Hemingway, September 1935"
           
           index = index + 1
           
               
           }
        if(bookNum == 2)
        {
            bookText.text = "I am young, I am twenty years old; yet I know nothing of life but despair, death, fear, and fatuous superficiality cast over an abyss of sorrow. I see how peoples are set against one another, and in silence, unknowingly, foolishly, obediently, innocently slay one another."
            index = index + 1
        }
        if(bookNum == 3)
        {
            bookText.text = "We will grind you revolutionists down under our heel, and we shall walk upon your faces. The world is ours, we are its lords, and ours it shall remain. As for the host of labor, it has been in the dirt since history began, and I read history aright. And in the dirt it shall remain so long as I and mine and those that come after us have the power. There is the word. It is the king of words—Power. Not God, not Mammon, but Power. Pour it over your tongue till it tingles with it. Power."
            index = index + 1
        }
        if(bookNum == 4)
        {
            bookText.text = "Is it not astonishing that, in the course of history, all human types except [the soulful human who possesses fantasy] have been in power?...Instead of expecting such a person to come along, we must expect gas warfare! And the culprit will be the philistine nature of the political and economical world powers. Everything evil or stupid in this world is not supernatural destiny, but rather a deadly form of lack of fantasy..."
            index = index + 1
        }
        if(bookNum == 5)
        {
            bookText.text = "But one who understands will not judge, and will have no pride. Before him I shall not be ashamed. Whoever has found himself can never again lose anything in this world. He who has grasped the human in himself understands all mankind."
            index = index + 1
            
        }
        
        bookText.numberOfLines = 10
        bookText.sizeToFit()
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            self.bookText.isHidden = true
            self.bookStack.isHidden = false
            
            if(self.index == 5)
            {
                print("finished")
                self.setupFinalScene()
            }
       }
        
        
    }
    func setupFinalScene()
    {
        backgroundTexture.isHidden = true
    }
    
    func particleLighting() {
        let node = SCNNode()
        let bonfireScene = SCNScene(named: "art.scnassets/BookBurning/bonfire.scn")!
        let particles = bonfireScene.rootNode.childNode(withName: "fire", recursively: true)
        
        let firePosX = particles!.position.x
        let firePosZ = particles!.position.z
        //z: -4, 3
        particles!.position.x = Float.random(in: -4.0..<3.0)
        particles!.position.z = Float.random(in: -4.0..<3.0)
    }
}
