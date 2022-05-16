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

func createText(text: String) -> SCNNode {
    //root node that will be added to the scene
    let node = SCNNode()
    
    //creates text object based on given string
    let text = SCNText(string: "Textual Rhetoric label test", extrusionDepth: 1)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.black
    text.materials = [material]
    
    //the poster needs a node to attach to in the actual scene
    let textNode = SCNNode(geometry: text)
    textNode.renderingOrder = 300
    
    //add the text node to the root node
    node.addChildNode(textNode)
    
    return node
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
