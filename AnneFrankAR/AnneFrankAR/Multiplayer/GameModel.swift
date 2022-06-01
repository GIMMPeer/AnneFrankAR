//
//  GameModel.swift
//  AnneFrankAR
//
//  Created by Lucas Greer on 6/1/22.
//

import Foundation
import UIKit
import GameKit

struct GameModel: Codable {
    public var state: String = ""
    public var players: [Player] = []
    public var chat: [Player: String] = [:]
}

extension GameModel {
    public func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    public func decode(data: Data) -> GameModel? {
        return try? JSONDecoder().decode(GameModel.self, from: data)
    }
}

struct Player: Codable, Hashable {
    public var name: String = ""
}
