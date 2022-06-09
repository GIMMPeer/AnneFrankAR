//
//  MainViewController.swift
//  AnneFrankAR
//
//  Created by Tri Nguyen on 4/1/22.
//
import UIKit
import RealityKit
import SceneKit
import ARKit
import AVKit
import AVFoundation
import SwiftUI

class MainViewController: UIViewController {
    
  
    //Button UI references
    @IBOutlet weak var ButtonUIView: UIView!
    @IBOutlet weak var HorizonalStackButtons: UIStackView!
    
    //Timeline Assets within UI
    @IBOutlet var RevealButton: UIButton!
    @IBOutlet var WatchVideoButton: UIButton!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var ConsealButton: UIButton!
    
    //Content UI references
    @IBOutlet weak var ContentUI: UIView!
    @IBOutlet weak var ContentTitleUI: UILabel!
    @IBOutlet weak var ContentTextUI: UILabel!
    @IBOutlet weak var ImageViewUI: UIImageView!
    @IBOutlet weak var ContentPageUI: UILabel!
    @IBOutlet weak var VideoPlayerUI: UIView!
    @IBOutlet weak var ToPrevPageUI: UIView!
    @IBOutlet weak var ToNextPageUI: UIView!
    
    //Decleare Instances
    var currentTimeLine:UIButton!
    var currentPage = 0;
    var contentDictionary = [UIButton:ContentItem]()
    var contentData: ContentData?
    
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue){}
    
    @IBAction func showVideo(_ sender: Any)
    {
        if let path = Bundle.main.path(forResource: "videoplayback", ofType: "mp4")
        {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion: {
                video.play()
            })
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        parseJson()
        setUpUI()
    }
    
    
    func setUpUI(){
        if contentData != nil{
            let contentList = contentData!.data
            for contentItem in contentList{
                let button = UIButton(type: .custom)
                let title:String = contentItem.title
                button.configuration = .plain()
                button.configuration?.title = title
                button.configuration?.image = UIImage(systemName: "rectangle")?.withRenderingMode(.alwaysOriginal)
                button.configuration?.imagePadding = 10
                button.configuration?.imagePlacement = .bottom
                
                button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                HorizonalStackButtons.alignment = .center
                HorizonalStackButtons.distribution = .fillEqually
                HorizonalStackButtons.spacing = 80
                HorizonalStackButtons.addArrangedSubview(button)
                contentDictionary[button] = contentItem
                
                //Timeline Buttons UI Setup
                WatchVideoButton.layer.borderWidth = 2
                WatchVideoButton.layer.borderColor = UIColor.black.cgColor
                RevealButton.layer.borderWidth = 2
                RevealButton.layer.borderColor = UIColor.black.cgColor
                ConsealButton.layer.borderWidth = 2
                ConsealButton.layer.borderColor = UIColor.black.cgColor
                
            }
            currentTimeLine = Array(contentDictionary)[0].key
            UpdateContentPage()
            UpdateUnlockedButton()
        }

    }

    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch:UITouch? = touches.first
        
        if(touch?.view == VideoPlayerUI){
            PlayVideo(current: currentTimeLine)
        }
        
        if(touch?.view == ToPrevPageUI){
            currentPage -= 1
            UpdateContentPage()
        }
        if(touch?.view == ToNextPageUI){
            currentPage += 1
            UpdateContentPage()
        }
    }
    
    //Timeline button action
    @IBAction func buttonAction(_ sender:UIButton){
        print("Send to book")
        currentTimeLine = sender
        currentPage = 0
        let timelineStatus = contentDictionary[currentTimeLine]?.unlocked
        if timelineStatus == false{
            return
        }
        if (sender.isSelected == true){
            ContentUI.isHidden = true;
            sender.isSelected = false
        }
        else{
            
            ContentUI.isHidden = false;
            sender.isSelected = true
        }
        
        for (btn,pageItem) in contentDictionary{
            if(pageItem.unlocked){
                if(btn == sender){
                    btn.configuration?.image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysOriginal)
                    continue
                }
                btn.configuration?.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysOriginal)
                btn.isSelected = false;
            }
        }
        UpdateContentPage()
    }
    
    //Pase json file from data.json
    func parseJson(){
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else{
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do{
            let jsonData = try Data(contentsOf: url)
            contentData = try JSONDecoder().decode(ContentData.self, from: jsonData)
        }catch{
            print("Error: \(error)")
        }
    }
    
    

    //Update page when toPrevView or toNextView triggered
    func UpdateContentPage(){
        let pageItem = contentDictionary[currentTimeLine]!.pageData
        
        if pageItem != nil{
            if(currentPage < 0){
                currentPage = pageItem.count - 1;
            }
            let pageIndex = currentPage%pageItem.count
            let currentPage = pageItem[pageIndex]
            ContentTitleUI.text = currentPage.title
            ContentTextUI.text = currentPage.context
            
            //Video hidden options
            if(currentPage.video == ""){
                VideoPlayerUI.isHidden = true
            } else{
                VideoPlayerUI.isHidden = false
            }
            
            //Image content hidden options
            if currentPage.image != ""{
                ImageViewUI.isHidden = false;
                ImageViewUI.image = UIImage(named: pageItem[pageIndex].image)
                
            } else{
                ImageViewUI.isHidden = true
                ImageViewUI.image = UIImage();
            }
            
            //Update page numbers
            ContentPageUI.text = "Page \(pageIndex+1) of \(pageItem.count)"
        }
   
    }
    
    //Call when new artifact or timeline unlocked
    func UpdateUnlockedButton(){
        for (btn,pageItem) in contentDictionary{
            if(pageItem.unlocked){
                if(btn.isSelected){
                    btn.configuration?.image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysOriginal)
                }
                btn.configuration?.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    

    
    func PlayVideo(current: UIButton){
        let currentPageItem = contentDictionary[current]!.pageData
        let VideoURL = currentPageItem[currentPage%currentPageItem.count].video
        if(VideoURL == ""){
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: VideoURL))
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController,animated: true){
            player.play()
        }
        
    }
    
}
