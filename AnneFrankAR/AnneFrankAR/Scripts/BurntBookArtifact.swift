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
    
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var bookStack: UIStackView!
    @IBOutlet weak var pageFireScene: SKView!
    @IBOutlet weak var bookText: UILabel!
    
    @IBOutlet weak var bookButton1: UIButton!
    @IBOutlet weak var bookButton2: UIButton!
    @IBOutlet weak var bookButton3: UIButton!
    @IBOutlet weak var bookButton4: UIButton!
    @IBOutlet weak var bookButton5: UIButton!
    var index:Int32 = 0
    
    @IBOutlet weak var backgroundTexture: UIImageView!
    @IBOutlet weak var pageTexture: UIImageView!
    @IBOutlet weak var pageText: UIStackView!
    
    let node = SCNNode()
    let particleNode = SKEmitterNode (fileNamed: "art.scnassets/BookBurning/FireParticle.sks")!
    let bonfireScene = SCNScene(named: "art.scnassets/BookBurning/Bonfire.scn")!
    lazy var openingBook = bonfireScene.rootNode.childNode(withName: "BookAnim", recursively: true)
    lazy var openingBookStatic = bonfireScene.rootNode.childNode(withName: "BookAnimOpen", recursively: true)
    
    
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
        pageFireScene.isHidden = true
        sceneView.delegate = self
        openingBook?.isHidden = true
        openingBookStatic?.isHidden = true
        openingBook?.animationPlayer(forKey: "BookAnim")?.stop()
        
        
        //setupGame()
        let scene = SCNScene()
        sceneView.scene = scene
        node.addChildNode(bonfireScene.rootNode)
        self.sceneView.scene!.rootNode.addChildNode(node)
        
        //sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
        
    
        let spriteScene = SKScene()
        let cameraNode = SKCameraNode()
        spriteScene.addChild(cameraNode)
        spriteScene.camera = cameraNode
        spriteScene.addChild(particleNode)
        pageFireScene.allowsTransparency = true
        spriteScene.backgroundColor = UIColor.clear
        pageFireScene.presentScene(spriteScene)
        
        cameraNode.position = CGPoint(x: spriteScene.size.width / 2, y: spriteScene.size.height / 2)
        let zoomOutAction = SKAction.scale(to: 150, duration: 0)
        cameraNode.run(zoomOutAction)

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
                self.openBook()
            }
        }else{
            print("nil")
        }
    }
    
    func openBook() {
        //Setup Anim
        openingBook?.isHidden = false
        openingBook?.animationPlayer(forKey: "BookAnim")?.play()
        let bookEndPos = SCNVector3Make(37.6, 24.6, 1.2)
        let moveBook = SCNAction.move(to: bookEndPos, duration: 0.75)
        //let rotateBook = node.childNode(withName: "BookAnim", recursively: true)?.action(forKey: <#T##String#>)
        //let rotateBook = openingBook?.action(forKey: "RotateToEuler")
        openingBook?.rotation = SCNVector4(0, 0, 0, 0)
        //let rotateBook = openingBook?.action(forKey: (openingBook?.actionKeys[0])!)
        //openingBook?.runAction(rotateBook!)
        openingBook?.runAction(moveBook)
        //Timer for few seconds then call setupBook()
        _ = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { timer in
            self.bookStack.isHidden = false
            self.backgroundTexture.isHidden = false
            self.bookText.isHidden = true
            self.openingBook?.isHidden = true
            self.openingBookStatic?.isHidden = false
        }
        
        
    }
    
    func setupReading(bookNum:Int32) {
        bookStack.isHidden = true
        bookText.isHidden = false
        pageFireScene.isHidden = false
        switch bookNum {
        case 1:
            bookText.text = "A Farewell to Arms follows one Frederic Henry, an American Lieutenant working with the Italian Ambulance service during WWI. The book includes many autobiographical details of Hemingway’s own life, focusing heavily on real accounts of the war. The violence is not glorified, and the tragedies that befall the characters were all too real for the Lost Generation - those who came of age during the war. Hemingway was targeted among other authors as 'corrupting foreign influences.' His works on and about the war were considered by the Nazi party to disrespect the memories of those who fought and died in WWI."
        case 2:
            bookText.text = "Titled “Im Westen nichts Neues” in the original German, this book’s main character joins the German army in WWI after being swayed by patriotic propaganda. He is quickly disillusioned by the horrors of reality shattering the romanticized version of war he had come to expect. In the end, the protagonist regrets returning home as he has become irrevocably changed by what he encountered on the front.Remarque’s work was described as “a literary betrayal of the soldiers of the World War.” His unflinching look at the horrors of war did nothing to build up the romanticized views of war and were therefore dangerous to the Nazi’s end goals."
        case 3:
            bookText.text = "Almansor takes place in the 1500s, following Almansor, an Arabic man returning from exile to find his lover. The book grapples with the character’s painful relationship with the dominant religion of Christianity. Most famously, it contains the line “Dort, wo man Bücher verbrennt, verbrennt man am Ende auch Menschen”: “Where they burn books, they will also ultimately burn people.Jewish authors such as Heinrich Heine were targeted heavily by the book burnings. The contents of the book didn’t matter so much as the fact that they were written by Jewish people to begin with. Any and all Jewish publications were seen as corrupting influences."
        case 4:
            bookText.text = "Out of the Dark is a collection of essays by Helen Keller, discussing among other things, socialism, activism as a blind person, and preventative care for children.While Helen Keller is famous for her condition, having been blinded and deafened at a young age, she went on to write many books and campaign for women’s suffrage, disability rights, labor rights, and peace. Keller was also an active socalist, a political ideology despised by the Nazi party. While her disabilities alone would have been enough for the Nazis to condemn her and her works to the pyre, her feminist and political ideologies sealed her books’ fate as staunchly un-German."
        case 5:
            bookText.text = "When it was first released, The Picture of Dorian Gray was called immoral and heavily criticized. Now considered a classic, the book follows the titular Dorian Gray and his foray into evil as a painting of himself molders and grows old in his attic, preserving his own youthful beauty and allowing him to avoid the responsibility of his reprehensible actions.The contents of the book aren’t as important as the author himself. Oscar Wilde was persecuted in his lifetime for his homosexuality. The Nazi regime did their best to erase homosexuality, and sent many gay men to death camps marked by pink triangles. The first Institute for Sexual Science founded by Magnus Hirschfeld in 1919 was razed in 1933, and housed a wealth of early queer theory before its distruction. Germany didn’t decriminalize homosexuality until 1969."
        default:
            print("Error: given number has no associated text")
        }
        index = index + 1
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
        
        pageFireScene.isHidden = false
        particleNode.position = CGPoint(x: 30, y: -10)
        particleNode.particleBirthRate = 5
        let wait = SKAction.wait(forDuration: 1.5)
        let move = SKAction.moveBy(x: -85, y: 0, duration: 10)
        move.timingMode = .easeOut
        particleNode.run(SKAction.sequence([wait, move]))
        var growthSpeed = 10.0
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { growTimer in
            self.particleNode.particleBirthRate += growthSpeed
            if self.particleNode.particleBirthRate >= 450 {
                growthSpeed = -5.0
            }
        }
        UIView.animate(withDuration: 10.0, delay: 1.2, options: .curveEaseOut, animations: {
            pageMask.frame.size = CGSize(width: 0, height: screen.height )
            textMask.frame.size = CGSize(width: 0, height: screen.height )
        }, completion: { finished in
            pageMask.frame.size = CGSize(width: screen.width, height: screen.height )
            textMask.frame.size = CGSize(width: screen.width, height: screen.height )
        })
        
        
        Timer.scheduledTimer(withTimeInterval: 11, repeats: false) { timer in
            self.particleNode.particleBirthRate = 5
            self.pageFireScene.isHidden = true

            self.bookText.isHidden = true
            self.backgroundTexture.isHidden = false
            self.bookStack.isHidden = false
            
            if(self.index == 1)
            {
                self.setupFinalScene()
            }
       }
        
        
    }
    func setupFinalScene()
    {
        backgroundTexture.isHidden = true
        bookText.isHidden = true
        self.bookStack.isHidden = true
        //node.childNode(withName: "Bonfire", recursively: true)?.removeFromParentNode()
        let bonfireScene = SCNScene(named: "art.scnassets/BookBurning/BonfireBig.scn")!
        node.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
        node.addChildNode(bonfireScene.rootNode)
        _ = Timer.scheduledTimer(withTimeInterval: 1.69, repeats: false) { growTimer in
            bonfireScene.rootNode.childNode(withName: "BookAnimClose", recursively: true)?.isHidden = true
        }
    }
}
