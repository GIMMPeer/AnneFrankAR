//
//  BurntBookArtifact.swift
//  AnneFrankAR
//
//  Created by Admin on 5/19/22.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit
import SwiftUI


class BurntBookArtifact: UIViewController, SCNSceneRendererDelegate
{
    var nodeName:String?
    
    
    
    var index:Int32 = 0
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var bookStack: UIStackView!
    
    //@IBOutlet weak var particleScene: SKScene!
    
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var bookText: UILabel!
    
    @IBOutlet weak var bookButton1: UIButton!
    
    @IBOutlet weak var bookButton2: UIButton!
    
    @IBOutlet weak var bookButton3: UIButton!
    
    @IBOutlet weak var bookButton4: UIButton!
    
    @IBOutlet weak var bookButton5: UIButton!
    
    @IBOutlet weak var backgroundTexture: UIImageView!
    
    @IBOutlet weak var fireAnim: UIView!
    @IBOutlet weak var pageTexture: UIImageView!
    @IBOutlet weak var pageText: UIStackView!
    
    let particleNode = SKEmitterNode (fileNamed: "art.scnassets/BookBurning/FireParticle.sks")!
    
    
    
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
        skView.isHidden = true
        //bookText.lineBreakMode = .byCharWrapping
        sceneView.delegate = self
        skView.isHidden = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        setupGame()
        
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
        
    
        let spriteScene = SKScene()

        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: spriteScene.size.width / 2, y: spriteScene.size.height / 2)
        spriteScene.addChild(cameraNode)
        spriteScene.camera = cameraNode
        spriteScene.addChild(particleNode)
        
        let zoomOutAction = SKAction.scale(to: 150, duration: 0)
        cameraNode.run(zoomOutAction)
        
            //spriteView.addChild(spriteScene)

        skView.allowsTransparency = true
        spriteScene.backgroundColor = UIColor.clear
        skView.presentScene(spriteScene)

        
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
            
            if(nodeName! == "Book" || nodeName! == "Cube")
            {
                
                //Setup Anim
                bookAnimation(animScene: SCNScene(named: "art.scnassets/BookBurning/OpeningBook")!, time: 2)
                
                //Timer for few seconds then call setupBook()
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in

                    self.setupBook()
                }
                
                //Remove animation
                
                
                
                
            }
        }else{
            print("nil")
        }
    }
    
    func bookAnimation(animScene:SCNScene, time:Int)
    {
        let bookNode = SCNNode()
        let bookOpen = animScene
        
        
        bookNode.addChildNode(bookOpen.rootNode)
        
        self.sceneView.scene!.rootNode.addChildNode(bookNode)
        
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false) { timer in
            
            bookNode.removeFromParentNode()
            
        }
    }
    
    func setupGame()
    {
        
        let node = SCNNode()
        let bonfireScene = SCNScene(named: "art.scnassets/BookBurning/Bonfire.scn")!
        
        
        //particleScene.addChild(particleNode)
        //node.addChildNode(particleScene)
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
        
        print("Hellooooooooooo?")
        bookStack.isHidden = true
        bookText.isHidden = false
        skView.isHidden = false
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
        let screen: CGRect = UIScreen.main.bounds
        
        let pageMask = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
        pageMask.backgroundColor = .blue
        let textMask = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
        textMask.backgroundColor = .blue
        view.addSubview(pageMask)
        view.addSubview(textMask)
        pageTexture.mask = pageMask
        bookText.mask = textMask
        
        skView.isHidden = false
        particleNode.position = CGPoint(x: 30, y: -15)
        let wait = SKAction.wait(forDuration: 2.5)
        let move = SKAction.moveBy(x: -75, y: 0, duration: 8)
        particleNode.run(SKAction.sequence([wait, move]))

        UIView.animate(withDuration: 10.0, delay: 1.2, options: .curveEaseOut, animations: {
            pageMask.frame.size = CGSize(width: 0, height: screen.height )
        }, completion: { finished in
            pageMask.frame.size = CGSize(width: screen.width, height: screen.height )
        })
        UIView.animate(withDuration: 10.0, delay: 1.0, options: .curveEaseOut, animations: {
            textMask.frame.size = CGSize(width: 0, height: screen.height )
        }, completion: { finished in
            textMask.frame.size = CGSize(width: screen.width, height: screen.height )
        })
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: 11, repeats: false) { timer in

            self.skView.isHidden = true

            self.bookText.isHidden = true
            self.backgroundTexture.isHidden = false
            self.bookStack.isHidden = false
            
            if(self.index == 1)
            {
                self.setupGame()
                
            }
            
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
        bookAnimation(animScene: SCNScene(named: "art.scnassets/BookBurning/ClosingAnimation")!, time: 5)
    }
}
