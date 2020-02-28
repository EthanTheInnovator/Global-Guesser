//
//  StartView.swift
//  GlobalGuesser
//
//  Created by Ethan Humphrey on 1/13/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

/*
    Welcome to my GlobalGuesser app.
    To play, start by entering your name and pressing begin.
    Then, you can see the image on the top with the map on the bottom.
    Tapping on a location on the map will place your guess.
    You can zoom in on the map.
    Tapping confirm location will zoom to show both your marker and the actual location.
    The distance between the actual location and your guess is then added to your total score.
    Your score is like golf; you want a lower score.
    At one point I tried to have a list of high scores, but I found a bug in SwiftUI
    Bugs:
        Sometimes you have to press confirm location twice. Idk why
        Sometimes the marker for "Your Guess" is the one for the right answer. Idk why
        Sometimes the zoom will zoom in a bit too far and cut off the text, Ik why but couldn't fix it.
    Everything else should be good. Have fun.
*/

import SwiftUI

extension AnyTransition {
    static var invertedSlide: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
        .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct StartView: View {
    @State var isStarted = false
    @State var isFinished = false
    @State var totalScore: Double = 0.0
    @State var playerName = ""
    
    @ObservedObject var settings = UserSettings()
    
    var body: some View {
        VStack {
            if isFinished {
                VStack{
                    HStack {
                        Spacer()
                    }
                    Text("Congratulations!")
                        .font(.title)
                        .fontWeight(.medium)
                        .padding()
                    Text("Your total score is \(String(format: "%\(0.2)f", Double(totalScore)))km away!")
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    Spacer()
//                    Text("Here's how you stack up against other players:")
//                        .padding()
//                    List {
//                        ForEach(settings.highScores, id: \.id) { highScore in
//                            Text("\(highScore.name): \(String(format: "%\(0.2)f", Double(highScore.score)))km")
//                                .foregroundColor(highScore == PlayerScore(name: self.playerName, score: self.totalScore) ? Color(.systemPurple) : Color(.label))
//                        }
//                    }
                    Button(action: {
                        withAnimation {
                            self.isStarted = true
                            self.isFinished = false
                        }
                    }) {
                        Text("Play Again")
                            .foregroundColor(.white)
                            .padding([.vertical, .horizontal], 10)
                            .background(Color(.systemPurple))
                            .cornerRadius(15)
                    }
                }
                .animation(.spring())
                .transition(.invertedSlide)
                .onAppear {
                    let playerScore = PlayerScore(name: self.playerName, score: self.totalScore)
                    if !self.settings.highScores.contains(where: { (thisScore) -> Bool in
                        return playerScore == thisScore
                    }) {
                        self.settings.highScores.append(playerScore)
                    }
                }
            }
            else if isStarted {
                VStack{
                    ContentView(totalScore: $totalScore, isFinished: $isFinished)
                }
                .animation(.spring())
                .transition(.invertedSlide)
            }
            else {
                VStack {
                   
                    Text("Welcome to Ethan's Global Guesser!")
                        .font(.title)
                        .padding()
                    Spacer()
                    TextField("Please enter your name to begin", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button(action: {
                        withAnimation {
                            self.isStarted = true
                        }
                    }) {
                        Text("Begin")
                            .foregroundColor(.white)
                            .padding([.vertical, .horizontal], 10)
                            .background(playerName.count == 0 ? Color(.systemGray) : Color(.systemPurple))
                            .cornerRadius(15)
                    }
                    .disabled(playerName.count == 0)
                    Spacer()
                }
                    .animation(.spring())
                    .transition(.invertedSlide)
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
