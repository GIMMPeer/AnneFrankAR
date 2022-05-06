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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("main view loaded")
    }
    
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue){
        print("go to main view controller")
    }
    
}
