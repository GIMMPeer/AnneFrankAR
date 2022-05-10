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

class MainViewController: UIViewController {
    
    //Button UI references
    @IBOutlet weak var ButtonUIView: UIView!
    @IBOutlet weak var HorizonalStackButtons: UIStackView!
    
    //Content UI references
    @IBOutlet weak var ContentUI: UIView!
    @IBOutlet weak var ContentTitleUI: UILabel!
    @IBOutlet weak var ContentTextUI: UILabel!
    @IBOutlet weak var ImageViewUI: UIImageView!
    @IBOutlet weak var ContentPageUI: UILabel!
    @IBOutlet weak var ToPrevPageUI: UIView!
    @IBOutlet weak var ToNextPageUI: UIView!
    //Decleare Instances
    var currentTimeLine:UIButton!
    var currentPage = 0;
    var buttonList = [UIButton:[PageItem]]()
    var contentData: ContentData?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        parseJson()
        setUpUI()
        print("main view loaded")
    }
    
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue){
        print("go to main view controller")
    }
    
    func parseJson(){
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else{
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do{
            let jsonData = try Data(contentsOf: url)
            contentData = try JSONDecoder().decode(ContentData.self, from: jsonData)
            print(contentData)
            print("Parse successful")
        }catch{
            print("Error: \(error)")
        }
    }
    
//    private func getTotalContents() -> Int{
//        return contentData!.data.count ?? 0
//    }
    
    func setUpUI(){
        if contentData != nil{
            let contentList = contentData!.data
            for contentItem in contentList{
                let button = UIButton(type: .system)
                let title:String = contentItem.title
                button.setTitle("\(title)", for: .normal)
                button.setImage(UIImage(named: "circle"), for: .normal)
                button.setImage(UIImage(named: "circle.fill"), for: .selected)
                button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                HorizonalStackButtons.alignment = .center
                HorizonalStackButtons.distribution = .fillEqually
                HorizonalStackButtons.spacing = 80
                HorizonalStackButtons.addArrangedSubview(button)
                buttonList[button] = contentItem.pageData

            }
            currentTimeLine = Array(buttonList)[0].key
            UpdateContentPage()
        }

    }
    
    @IBAction func buttonAction(_ sender:UIButton){
        currentTimeLine = sender
        currentPage = 0
        if (sender.isSelected == true){
            ContentUI.isHidden = true;
            sender.isSelected = false
        }
        else{
            ContentUI.isHidden = false;
            sender.isSelected = true
        }
        
        for (btn,pageItem) in buttonList{
            if(btn != sender){
                btn.isSelected = false
            } else{
                
                var pageIndex = currentPage%pageItem.count
                ContentTitleUI.text = pageItem[pageIndex].title
                ContentTextUI.text = pageItem[pageIndex].context
                if pageItem[pageIndex].image != ""{
                    ImageViewUI.image = UIImage(named: pageItem[pageIndex].image)
                }else{
                    ImageViewUI.image = UIImage();
                }
                ContentPageUI.text = "Page \(pageIndex+1) of \(pageItem.count)"
            }
            
        }
        
        
        
        ButtonUIView.alpha = 1
    }
    
    func UpdateContentPage(){
        var pageItem = buttonList[currentTimeLine]!
        if pageItem != nil{
            if(currentPage < 0){
                currentPage = pageItem.count - 1;
            }
            var pageIndex = currentPage%pageItem.count
            ContentTitleUI.text = pageItem[pageIndex].title
            ContentTextUI.text = pageItem[pageIndex].context
            if pageItem[pageIndex].image != ""{
                ImageViewUI.image = UIImage(named: pageItem[pageIndex].image)
            } else{
                ImageViewUI.image = UIImage();
            }
            ContentPageUI.text = "Page \(pageIndex+1) of \(pageItem.count)"
        }
   
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch:UITouch? = touches.first
//        if(touch?.view == sceneView){
//            ContentUI.isHidden = true
//            ButtonUIView.alpha = 0.5
//            for (btn,pageItem) in buttonList{
//                btn.isSelected = false
//            }
//        } else{
//            ButtonUIView.alpha = 1
//        }
        
        if(touch?.view == ToPrevPageUI){
            currentPage -= 1
            UpdateContentPage()
        }
        if(touch?.view == ToNextPageUI){
            currentPage += 1
            UpdateContentPage()
        }
    }
    
}
