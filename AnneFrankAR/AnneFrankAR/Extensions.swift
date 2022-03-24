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
    let node = SCNNode()
    
    //Add First Box
    let firstBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
    firstBox.firstMaterial?.diffuse.contents = UIImage(named: img)
    
    let firstBoxNode = SCNNode(geometry: firstBox)
    firstBoxNode.renderingOrder = 200
    
    node.addChildNode(firstBoxNode)
    
    //Add Masked Box
    let maskedBox = SCNBox(width: width, height: height, length: isDoor ? doorLength : length, chamferRadius: 0)
    maskedBox.firstMaterial?.diffuse.contents = UIColor.blue
    maskedBox.firstMaterial?.transparency = 0.00001
    
    let maskedBoxNode = SCNNode(geometry: maskedBox)
    maskedBoxNode.renderingOrder = 100
    maskedBoxNode.position = SCNVector3.init(width, 0, 0)
    
    node.addChildNode(maskedBoxNode)
    return node
}

func createPoster(image: String) -> SCNNode {
    let node = SCNNode()
    
    let poster = SCNBox(width: 0.03, height: 0.5, length: 0.3, chamferRadius: 0)
    poster.firstMaterial?.diffuse.contents = UIImage(named: image)
    
    let posterNode = SCNNode(geometry: poster)
    posterNode.renderingOrder = 300
    
    node.addChildNode(posterNode)
    
    return node
}

extension FloatingPoint {
    var degreesToRadians : Self {
        return self * .pi / 180
    }
    
    var radiansToDegrees : Self {
        return self * 180 / .pi
    }
}
