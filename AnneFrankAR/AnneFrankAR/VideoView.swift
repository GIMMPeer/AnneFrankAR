import UIKit
import AVKit
import AVFoundation
import RealityKit

class VideoView: UIViewController {
    
    @IBOutlet var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayVideo()
    }
        
        private func PlayVideo(){
            
            //might have to convert the mp4 videos to m4v later down the line
            //There are also 3 speech videos and one of the crowd at a rally
            
            //Here's a working example
            
            debugPrint("Button clicked for vid")
            if let path = Bundle.main.path(forResource: "video1_Speech", ofType: "mp4")
            {
                let video = AVPlayer(url: URL(fileURLWithPath: path))
                let videoPlayer = AVPlayerViewController()
                videoPlayer.player = video
                
                present(videoPlayer, animated: true, completion: {
                    video.play()
                })
            }
            
    }
}
