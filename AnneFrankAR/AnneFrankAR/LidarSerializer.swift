//
//  LidarSerializer.swift
//  AnneFrankAR
//
//  Created by Lucas Greer on 6/8/22.
//

import Foundation
import RealityKit
import ARKit

class PointCloudEncoder {
    static func encodeData(session: ARSession) -> Data? {
        var m: ARWorldMap?
        session.getCurrentWorldMap {map,error in
            if (error == nil) {
                m = map
            } else {
                print("\(String(describing: error))")
                m = nil
            }
        }
        var a: NSKeyedArchiver = NSKeyedArchiver(requiringSecureCoding: false)
        m?.encode(with: a)
        return a.encodedData
    }
    
    static func decodeData(data: Data) -> ARWorldMap? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
    }
    
    /*static func decodeData(data: Data) -> ARWorldMap? {
        var points: [vector_float3]?
        points = try? JSONDecoder().decode([vector_float3].self, from: data)
        var cloud: ARPointCloud?
        return nil
    }*/
}
