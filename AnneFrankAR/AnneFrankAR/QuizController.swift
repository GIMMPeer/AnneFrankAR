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
    var questionArr = [Poster]()
    
    var index:Int = 0
    var answerVal:Int?
    var correct:Bool = false
    var totalCorrect:Int = 0
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
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
        
       
        let posterA = Poster(image: UIImage(named: "firstContent")!, value: [1,3])
        let posterB = Poster(image: UIImage(named: "secondContent")!, value: [2,4])
        let posterC = Poster(image: UIImage(named:"thirdContent")!, value:[7])
        
        questionArr.append(posterA)
        questionArr.append(posterB)
        questionArr.append(posterC)
        questionLabel.text = "What principle of propaganda does this poster represent?"
        questionLabel.numberOfLines = 5
        setupQuestion()
    }
    
    private func setupQuestion()
    {
        if(index >= questionArr.count)
        {
            //Display final 
            return
        }
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
            totalCorrect += 1
            index += 1
            setupQuestion()
        }
        else
        {
            print("Incorrect")
            index += 1
            setupQuestion()
        }
        totalScore.text = String(totalCorrect) + "/10"
            
    }
}

struct Poster
{
    let image:UIImage
    let value: [Int]
}
