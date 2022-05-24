//
//  QuizController.swift
//  AnneFrankAR
//
//  Created by Admin on 5/24/22.
//

import Foundation
import UIKit

class QuizController: UIViewController
{
    var questionArr = [Poster]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQuestions()
        let posterA = Poster(image: UIImage(named: "firstContent")!, value: [1,3])
        let posterB = Poster(image: UIImage(named: "secondContent")!, value: [2,4])
        
        questionArr.append(posterA)
        questionArr.append(posterB)
    }
    
    private func setupQuestions()
    {
        
    }
    
    private func checkAnswer()
    {
        
    }
}

struct Poster
{
    let image:UIImage
    let value: [Int]
}
