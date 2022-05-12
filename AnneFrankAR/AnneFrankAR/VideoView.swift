import UIKit
import AVKit
import AVFoundation
import RealityKit

class VideoView: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    @IBAction func playVideo(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "video1_Speech", ofType: "mp4") else{
            debugPrint("video1_Speech.mp4 not found")
            return
        }
        let player = AVPlayer(url:URL(fileURLWithPath: path))
        
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true){
            player.play()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayVideo()
    }
        
        private func PlayVideo(){
            
            //might have to convert the mp4 videos to m4v later down the line
            //There are also 3 speech videos and one of the crowd at a rally
            
            //Need to set up a button in the main scene somewhere to open the video view
            //Only going to set up a single video for now as proof. Can easily set up the
            //other videos later once the UI is more fleshed out. May have to find more.
            
            guard let path = Bundle.main.path(forResource: "art.sceneassets/video1_Speech", ofType: "mp4") else{
                debugPrint("video1_Speech.mp4 not found")
                return
            }
            let player = AVPlayer(url:URL(fileURLWithPath: path))
            
            let layer = AVPlayerLayer(player: player)
            layer.frame = view.bounds
            layer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(layer)
            
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true){
                player.play()
            }
    }
}
