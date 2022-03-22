//
//  ViewController.swift
//  AnneFrankAR
//
//  Created by Tri Nguyen on 3/4/22.
//

import UIKit
import AVKit
import AVFoundation
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! PosterInteractiveExample.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        PlayVideo()
    }
        
        private func PlayVideo(){
            //might have to convert the mp4 videos to m4v - Ivar
            //There are also 3 videos of speeches and one of the crowd at a rally
            guard let path = Bundle.main.path(forResource: "video1_Speech", ofType: "mp4") else{
                debugPrint("video1_Speech.mp4 not found")
                return
            }
            let player = AVPlayer(url:URL(fileURLWithPath: path))
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true){
                player.play()
            }
    }
}
