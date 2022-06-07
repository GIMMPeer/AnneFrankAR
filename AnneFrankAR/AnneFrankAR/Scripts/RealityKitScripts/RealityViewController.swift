//
//  RealityViewController.swift
//  AnneFrankAR
//
//  Created by Admin on 6/7/22.
//

import SwiftUI
import RealityKit
import ARKit

struct RealityViewController : View {
        
    var body: some View {
        ZStack(alignment: .bottom)
        {
            ARViewContainer()
            
           
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if
            ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        
        arView.environment.sceneUnderstanding.options = .occlusion

        let scene = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(scene)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


class RealityViewVHC: UIHostingController<RealityViewController>
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder, rootView: RealityViewController())
    }
}
