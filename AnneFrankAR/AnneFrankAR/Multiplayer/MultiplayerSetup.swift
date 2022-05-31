//
//  MultiplayerSetup.swift
//  AnneFrankAR
//
//  Created by Lucas Greer on 5/31/22.
//

import Foundation
import GameKit

func initializeMultiplayer(view: UIViewController) {
    GKLocalPlayer.local.authenticateHandler = { viewController, error in
        if let viewController = viewController {
            // Present the view controller so the player can sign in.
            view.present(viewController, animated: true)
            return
        }
        if error != nil {
            // Player could not be authenticated.
            // Disable Game Center in the game.
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            view.present(alert, animated: true)
            return
        }
        
        // Perform any other configurations as needed (for example, access point).
    }
}
