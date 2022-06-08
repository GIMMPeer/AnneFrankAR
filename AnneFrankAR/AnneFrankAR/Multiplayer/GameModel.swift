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

struct Player: Codable, Equatable, Identifiable {
    public var id: UUID
    public var name: String = ""
    public var correctQuestions: Int = 0
    public var totalQuestions: Int = 0
}

struct ChatMessage: Codable, Identifiable, Equatable {
    public var id: UUID
    public var player: Player
    public var message: String
}
