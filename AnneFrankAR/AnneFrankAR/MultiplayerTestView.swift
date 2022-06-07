//
//  MultiplayerTestView.swift
//  AnneFrankAR
//
//  Created by Lucas Greer on 6/1/22.
//

import SwiftUI
import GameKit

struct MultiplayerTestView: View {
    @State var text: String = ""
    var me: Player = Player(id:.init(), name: GKLocalPlayer.local.alias)
    @State var model: GameModel = GameModel()
    @State var match: GKMatch
    var gkm = GameKitManager()
    var body: some View {
        GeometryReader() { geometry in
        HStack(alignment: .top) {
            List {
                ForEach(model.players) { player in
                    Text(player.name)
                }
            }
            .frame(maxWidth: geometry.size.width / 3)
        VStack(alignment: .leading) {
            ScrollViewReader() { value in
                        ScrollView(Axis.Set.vertical,   showsIndicators: true) {
                            VStack(alignment: .leading) {
                            ForEach(model.chat) { message in
                            VStack(alignment: .leading) {
                                Text(message.player.name)
                                    .fontWeight(.bold)
                                Text(message.message)
                                Text("")
                            }
                            .id(message.id)
                        }
                        .onChange(of: model.chat.count) { _ in
                            value.scrollTo(model.chat.last?.id)
                        }
                    }
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
            Spacer()
            TextField("Chat", text: $text, prompt: Text("Enter a message"))
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    model.chat.append(.init(id:.init(), player:me, message:text))
                    do {
                        try match.sendData(toAllPlayers: model.encode()!, with: .reliable)
                    }
                    catch {
                        print("Error")
                    }
                    text = ""
                }
        }
        }
        .onLoad {
            model.players.append(me)
            gkm.gM = model
            gkm.mtv = self
            match.delegate = gkm
            do {
                try match.sendData(toAllPlayers: model.encode()!, with: .reliable)
            }
            catch {
                print("Error")
            }
        }
        }
    }
}

struct MultiplayerTestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultiplayerTestView(match: GKMatch())
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}
