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
    
    //@IBOutlet weak var fireAnim: UIView!
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
        bookStack.isHidden = true
        bookText.isHidden = false
        skView.isHidden = false
       if(bookNum == 1)
        {
           bookText.text = "A Farewell to Arms follows one Frederic Henry, an American Lieutenant working with the Italian Ambulance service during WWI. The book includes many autobiographical details of Hemingway’s own life, focusing heavily on real accounts of the war. The violence is not glorified, and the tragedies that befall the characters were all too real for the Lost Generation - those who came of age during the war. Hemingway was targeted among other authors as 'corrupting foreign influences.' His works on and about the war were considered by the Nazi party to disrespect the memories of those who fought and died in WWI."
           
           index = index + 1
           
               
           }
        if(bookNum == 2)
        {
            bookText.text = "Titled “Im Westen nichts Neues” in the original German, this book’s main character joins the German army in WWI after being swayed by patriotic propaganda. He is quickly disillusioned by the horrors of reality shattering the romanticized version of war he had come to expect. In the end, the protagonist regrets returning home as he has become irrevocably changed by what he encountered on the front.Remarque’s work was described as “a literary betrayal of the soldiers of the World War.” His unflinching look at the horrors of war did nothing to build up the romanticized views of war and were therefore dangerous to the Nazi’s end goals."
            
            index = index + 1
        }
        if(bookNum == 3)
        {
            bookText.text = "Almansor takes place in the 1500s, following Almansor, an Arabic man returning from exile to find his lover. The book grapples with the character’s painful relationship with the dominant religion of Christianity. Most famously, it contains the line “Dort, wo man Bücher verbrennt, verbrennt man am Ende auch Menschen”: “Where they burn books, they will also ultimately burn people.Jewish authors such as Heinrich Heine were targeted heavily by the book burnings. The contents of the book didn’t matter so much as the fact that they were written by Jewish people to begin with. Any and all Jewish publications were seen as corrupting influences."
            
            index = index + 1
        }
        if(bookNum == 4)
        {
            bookText.text = "Out of the Dark is a collection of essays by Helen Keller, discussing among other things, socialism, activism as a blind person, and preventative care for children.While Helen Keller is famous for her condition, having been blinded and deafened at a young age, she went on to write many books and campaign for women’s suffrage, disability rights, labor rights, and peace. Keller was also an active socalist, a political ideology despised by the Nazi party. While her disabilities alone would have been enough for the Nazis to condemn her and her works to the pyre, her feminist and political ideologies sealed her books’ fate as staunchly un-German."
            
            index = index + 1
        }
        if(bookNum == 5)
        {
            bookText.text = "When it was first released, The Picture of Dorian Gray was called immoral and heavily criticized. Now considered a classic, the book follows the titular Dorian Gray and his foray into evil as a painting of himself molders and grows old in his attic, preserving his own youthful beauty and allowing him to avoid the responsibility of his reprehensible actions.The contents of the book aren’t as important as the author himself. Oscar Wilde was persecuted in his lifetime for his homosexuality. The Nazi regime did their best to erase homosexuality, and sent many gay men to death camps marked by pink triangles. The first Institute for Sexual Science founded by Magnus Hirschfeld in 1919 was razed in 1933, and housed a wealth of early queer theory before its distruction. Germany didn’t decriminalize homosexuality until 1969."

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
