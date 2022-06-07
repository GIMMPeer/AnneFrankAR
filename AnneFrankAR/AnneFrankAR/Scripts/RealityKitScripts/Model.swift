//
//  Model.swift
//  AnneFrankAR
//
//  Created by Alan on 6/7/22.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName: String
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String)
    {
        self.modelName = modelName
        
        let fileName = modelName + ".usdc"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                //Handle our error
                print("DEBUG: Unable to load modelEntity for modelName: \(self.modelName)")
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                print("DEBUG : Succesfully loaded model \(self.modelName)")
            })
    }
}
