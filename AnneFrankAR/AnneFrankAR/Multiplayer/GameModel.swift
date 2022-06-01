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
    public var chat: [ChatMessage] = []
}

extension GameModel {
    public func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    public func decode(data: Data) -> GameModel? {
        return try? JSONDecoder().decode(GameModel.self, from: data)
    }
}

struct Player: Codable {
    public var name: String = ""
}

struct ChatMessage: Codable, Identifiable {
    public var id: UUID
    public var player: Player
    public var message: String
}
