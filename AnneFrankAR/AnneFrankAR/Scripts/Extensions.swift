//
//  Extensions.swift
//  AnneFrankAR
//
//  Created by Jessna Rodriguez on 3/21/22.
//

import Foundation
import SceneKit
import ARKit

var width : CGFloat = 0.03
var height : CGFloat = 2
var length : CGFloat = 2

var doorLength : CGFloat = 0.6

func createBox(isDoor : Bool, img : String) -> SCNNode {
    //root node that will be added to the scene
    let node = SCNNode()
    
    //Add First Box, this is the textured inside wall
    let firstBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
    //add the image texture
    firstBox.firstMaterial?.diffuse.contents = UIImage(named: img)
    
    //the box object needs a node to attach to in the actual scene
    let firstBoxNode = SCNNode(geometry: firstBox)
    firstBoxNode.renderingOrder = 200
    //add the box node to the root node
    node.addChildNode(firstBoxNode)
//--------------------------------------------------------------------------------------------
    //Add Masked Box, this is the outside occluded box so things look hidden
    let maskedBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
    maskedBox.firstMaterial?.diffuse.contents = UIColor.blue
    //the transparency is the main thing needed here, it's what makes the box invisible and occluded
    maskedBox.firstMaterial?.transparency = 0.00001
    
    //the invisible wall needs a node to attach to in the actual scene
    let maskedBoxNode = SCNNode(geometry: maskedBox)
    maskedBoxNode.renderingOrder = 100
    maskedBoxNode.position = SCNVector3.init(width, 0, 0)
    
    //add the wall node to the root node
    node.addChildNode(maskedBoxNode)
    return node
}

func createPoster(image: String) -> SCNNode {
    //root node that will be added to the scene
    let node = SCNNode()
    
    //creates box with poster image texture
    let poster = SCNBox(width: 0.03, height: 0.5, length: 0.3, chamferRadius: 0)
    poster.firstMaterial?.diffuse.contents = UIImage(named: image)
    
    //the poster needs a node to attach to in the actual scene
    let posterNode = SCNNode(geometry: poster)
    posterNode.renderingOrder = 300
    
    //add the poster node to the root node
    node.addChildNode(posterNode)
    
    return node
}

func createText(text: String, parent: SCNNode) -> SCNNode {
    //root node that will be added to the scene
    let node = SCNNode()
    //subScene.rootNode.childNode(withName: "Cylinder", recursively: true)!
    //creates text object based on given string
    let text = SCNText(string: "Textual Rhetoric label test", extrusionDepth: 1)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.black
    text.materials = [material]
    //text.containerFrame = CGRect(x: parent.position.x, y: parent.position.y, width: 60, height: 20)
    
    //the poster needs a node to attach to in the actual scene
    let textNode = SCNNode(geometry: text)
    textNode.renderingOrder = 300
    
    
    
    //add the text node to the parent node
    parent.addChildNode(textNode)
    
    return node
}

// used to be reused code in the create portal function
 func buildRoom(num: Int, node: SCNNode) {
     var leftWall: SCNNode?

     var rightWall: SCNNode?

     var topWall: SCNNode?

     var bottomWall: SCNNode?

     var backWall: SCNNode?

     var leftDoorSide: SCNNode?

     var rightDoorSide: SCNNode?

     if num == 1 {
         leftWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Wall_1.png")
         rightWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Wall_1.png")
         topWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Floor.png")
         bottomWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Floor.png")
         backWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Wall_1.png")
         leftDoorSide = createBox(isDoor: true, img: "art.scnassets/Wall Textures/Floor.png")
         rightDoorSide = createBox(isDoor: true, img: "art.scnassets/Wall Textures/Floor.png")
     } else if num == 2 {
         leftWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/wand4.png")
         rightWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/wand4.png")
         topWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Floor.png")
         bottomWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/Walkway_Dark_2.png")
         backWall = createBox(isDoor: false, img: "art.scnassets/Wall Textures/wand4.png")
         leftDoorSide = createBox(isDoor: true, img: "art.scnassets/Wall Textures/Floor.png")
         rightDoorSide = createBox(isDoor: true, img: "art.scnassets/Wall Textures/Floor.png")
     }

     leftWall!.position = SCNVector3.init((-length / 2) + width, 0, 0)
     leftWall!.eulerAngles = SCNVector3.init(0, 180.0.degreesToRadians, 0)

     rightWall!.position = SCNVector3.init((length / 2) - width, 0, 0)

     topWall!.position = SCNVector3.init(0, (height / 2) - width, 0)
     topWall!.eulerAngles = SCNVector3.init(0, 0, 90.0.degreesToRadians)

     bottomWall!.position = SCNVector3.init(0, (-height / 2) + width, 0)
     bottomWall!.eulerAngles = SCNVector3.init(0, 0, -90.0.degreesToRadians)

     backWall!.position = SCNVector3.init(0, 0, (-length / 2) + width)
     backWall!.eulerAngles = SCNVector3.init(0, 90.0.degreesToRadians, 0)

     leftDoorSide!.position = SCNVector3.init((-length / 2 + width) + (doorLength / 2), 0, (length / 2) - width)
     leftDoorSide!.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)

     rightDoorSide!.position = SCNVector3.init((length / 2 - width) - (doorLength / 2), 0, (length / 2) - width)
     rightDoorSide!.eulerAngles = SCNVector3.init(0, -90.0.degreesToRadians, 0)

     node.addChildNode(leftWall!)
     node.addChildNode(rightWall!)
     node.addChildNode(topWall!)
     node.addChildNode(bottomWall!)
     node.addChildNode(backWall!)
     node.addChildNode(leftDoorSide!)
     node.addChildNode(rightDoorSide!)

     // create light, otherwise the portal would be black
     let light = SCNLight()
     // omni has worked the best on image textures, but could be better
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
     // This points the light in a specific direction
     let constraint = SCNLookAtConstraint(target: bottomWall)
     constraint.isGimbalLockEnabled = true

     // This is what actually places the light in the scene
     let lightNode = SCNNode()
     lightNode.light = light
     lightNode.position = SCNVector3.init(0, 4, 0)
     lightNode.constraints = [constraint]
     node.addChildNode(lightNode)
 }

//couple helper functions for rotation
extension FloatingPoint {
    var degreesToRadians : Self {
        return self * .pi / 180
    }
    
    var radiansToDegrees : Self {
        return self * 180 / .pi
    }
}
