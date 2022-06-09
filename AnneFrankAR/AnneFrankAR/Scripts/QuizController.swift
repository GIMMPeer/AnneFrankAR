//
//  QuizController.swift
//  AnneFrankAR
//
//  Created by Alan on 5/24/22.
//

import Foundation
import UIKit

class QuizController: UIViewController
{
    //Button UI References
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var ans1Button: UIButton!
    @IBOutlet var ans2Button: UIButton!
    @IBOutlet var ans3Button: UIButton!
    @IBOutlet var ans4Button: UIButton!
    @IBOutlet var ans5Button: UIButton!
    @IBOutlet var ans6Button: UIButton!
    @IBOutlet var ans7Button: UIButton!
    @IBOutlet var ans8Button: UIButton!
    
    var questionArr = [Poster]()
    
    @IBOutlet weak var feedbackOverlay: UIView!
    
    var index:Int = 0
    var answerVal:Int?
    var correct:Bool = false
    var finished:Bool = false
    var totalCorrect:Int = 0
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var feedbackText: UILabel!
    
    @IBOutlet weak var answerFeedback: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBAction func `continue`(_ sender: Any) {
        feedbackOverlay.isHidden = true
        if(finished)
        {
            navigationController?.popViewController(animated: true)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func answerBandwagon(_ sender: Any) {
        answerVal = 1
        checkAnswer()
    }
    
    @IBAction func answerScapegoating(_ sender: Any) {
        answerVal = 2
        checkAnswer()
    }
    @IBAction func answerGlittering(_ sender: Any) {
        answerVal = 3
        checkAnswer()
    }
    @IBAction func answerTransfer(_ sender: Any) {
        answerVal = 4
        checkAnswer()
    }
    
    @IBAction func answerTestimonials(_ sender: Any) {
        answerVal = 5
        checkAnswer()
    }
    @IBAction func answerPlainFolk(_ sender: Any) {
        answerVal = 6
        checkAnswer()
    }
    
    @IBAction func answerCard(_ sender: Any) {
        answerVal = 7
        checkAnswer()
    }
    @IBAction func answerFear(_ sender: Any) {
        answerVal = 8
        checkAnswer()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackOverlay.isHidden = true
       
        let posterA = Poster(image: UIImage(named: "firstContent")!, value: [1,3], feedback: "This poster is a primary example of Scapegoating")
        let posterB = Poster(image: UIImage(named: "secondContent")!, value: [2,4], feedback: "This poster is a primary example of Fearmongering")
        let posterC = Poster(image: UIImage(named:"thirdContent")!, value:[7], feedback: "This poster is a primary example of Card Tactics")
        
        questionArr.append(posterA)
        questionArr.append(posterB)
        questionArr.append(posterC)
        questionLabel.text = "What principle of propaganda does this poster represent?"
        questionLabel.numberOfLines = 5
        feedbackText.numberOfLines = 5
        setupQuestion()
        setUpUI()
    }
    
    func setUpUI(){
        //Button Appearance
        continueButton.layer.borderWidth = 2
        continueButton.layer.borderColor = UIColor.black.cgColor
        ans1Button.layer.borderWidth = 2
        ans1Button.layer.borderColor = UIColor.black.cgColor
        ans2Button.layer.borderWidth = 2
        ans2Button.layer.borderColor = UIColor.black.cgColor
        ans3Button.layer.borderWidth = 2
        ans3Button.layer.borderColor = UIColor.black.cgColor
        ans4Button.layer.borderWidth = 2
        ans4Button.layer.borderColor = UIColor.black.cgColor
        ans5Button.layer.borderWidth = 2
        ans5Button.layer.borderColor = UIColor.black.cgColor
        ans6Button.layer.borderWidth = 2
        ans6Button.layer.borderColor = UIColor.black.cgColor
        ans7Button.layer.borderWidth = 2
        ans7Button.layer.borderColor = UIColor.black.cgColor
        ans8Button.layer.borderWidth = 2
        ans8Button.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setupQuestion()
    {
        
        correct = false
        posterImage.image = questionArr[index].image
        
        
    }
    
    private func checkAnswer()
    {
        for answerValue in questionArr[index].value {
            
            print(answerValue)
            
            if(answerVal == answerValue)
            {
                correct = true
                
            }
            
            
        }
        if(correct)
        {
            
            feedbackOverlay.isHidden = false
            feedbackText.text = questionArr[index].feedback
            answerFeedback.text = "You are correct"
            
            
            totalCorrect += 1
            
            
        }
        else
        {
            print("Incorrect")
            feedbackOverlay.isHidden = false
            feedbackText.text = questionArr[index].feedback
            answerFeedback.text = "You are incorrect"
        
        }
        
        if(index >= questionArr.count - 1)
        {
            feedbackText.text = "You are finished. Please press continue."
            answerFeedback.text = ""
            finished = true
        }
        else
        {
            index += 1
            setupQuestion()
        }
        
            
    }
}

struct Poster
{
    let image:UIImage
    let value: [Int]
    let feedback: String
}
