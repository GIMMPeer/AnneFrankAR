//
//  MultiplayerTestView.swift
//  AnneFrankAR
//
//  Created by Lucas Greer on 6/1/22.
//

import SwiftUI

struct MultiplayerTestView: View {
    @State var text: String = ""
    var me: Player = Player(name: "Jimmy")
    @State var model: GameModel = GameModel(chat: [.init(id:.init(), player:.init(name: "Jeff"), message: "hello people"), .init(id:.init(), player:.init(name: "Bob"), message: "shut up"), .init(id:.init(), player:.init(name: "Jeff"), message: "you shut up"),.init(id:.init(), player:.init(name: "Moderator"), message: "Calm down, this is a memorial not a Discord chat."),.init(id:.init(), player:.init(name: "Jeff"), message: "never tyrant"), .init(id:.init(), player:.init(name: "Jeff"), message: "never tyrant"), .init(id:.init(), player:.init(name: "Bob"), message: "never tyrant"), .init(id:.init(), player:.init(name: "Jeff"), message: "never tyrant"), .init(id:.init(), player:.init(name: "Bob"), message: "never tyrant"), .init(id:.init(), player:.init(name: "Jeff"), message: "never tyrant"), .init(id:.init(), player:.init(name: "Bob"), message: "never tyrant"), .init(id:.init(), player:.init(name: "Jeff"), message: "never tyrant we should dethrone the mods")])
    var body: some View {
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
                    text = ""
                }
        }
    }
}

struct MultiplayerTestView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerTestView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
