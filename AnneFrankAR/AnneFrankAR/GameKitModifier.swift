//
//  GameKitModifier.swift
//  AnneFrankAR
//
//  Created by Lucas Greer on 6/7/22.
//

import Foundation
import SwiftUI
import GameKit

class GameKitManager: NSObject {
    var gM: GameModel?
    var mtv: MultiplayerTestView?
}

extension GameKitManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        gM = gM!.decode(data: data)
        if (!gM!.players.contains(mtv!.me)) {
            gM!.players.append(mtv!.me)
        }
        mtv!.model = gM!
    }
}
