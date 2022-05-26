//
//  PropagandaLesson.swift
//  AnneFrankAR
//
//  Created by Admin on 5/25/22.
//

import Foundation
import UIKit


class PropagandaLesson:UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeFunc(gesture: UISwipeGestureRecognizer) throws
    {
        if gesture.direction == .left
        {
            performSegue(withIdentifier: "Left", sender: self)
        }
        if gesture.direction == .right
        {
            performSegue(withIdentifier: "Right", sender: self)
        }
        
    }
}


