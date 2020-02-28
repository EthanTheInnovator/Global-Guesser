//
//  ContentView.swift
//  GlobalGuesser
//
//  Created by Ethan Humphrey on 1/7/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @Binding var totalScore: Double
    @Binding var isFinished: Bool
    @State var allLocations = Location.getAllLocations().shuffled()
    @State var currentLocation = Location.getAllLocations().first!
    @State var currentIndex = 0
    @State var isSelecting = true
    @State var selectedPoint: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            VStack {
                Text((isSelecting || selectedPoint == nil) ? "Find this location on the map!" : "You were \(String(format: "%\(0.2)f", currentLocation.coordinate.distance(from: selectedPoint!)))km away from the correct location!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding([.top, .horizontal])
                    .animation(.none)
                currentLocation.image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .shadow(radius: 5)
                    .transition(.opacity)
            }
            .padding(.bottom)
            if isSelecting {
                Text("Tap to place your marker")
                    .transition(.opacity)
            }
            MapView(currentLocation: $currentLocation, isSelecting: $isSelecting, selectedPoint: $selectedPoint)
                .cornerRadius(20)
                .padding([.horizontal, .bottom])
                .edgesIgnoringSafeArea(.bottom)
                .shadow(radius: 5)
            HStack {
                Button(action: {
                    withAnimation {
                        self.isSelecting.toggle()
                        if self.isSelecting {
                            self.currentIndex += 1
                            if self.currentIndex < self.allLocations.count {
                                self.currentLocation = self.allLocations[self.currentIndex]
                                self.selectedPoint = nil
                            }
                            else {
                                self.isFinished = true
                                self.allLocations.shuffle()
                                self.currentIndex = 0
                            }
                        }
                        else {
                            self.totalScore += self.currentLocation.coordinate.distance(from: self.selectedPoint!)
                        }
                    }
                }) {
                    Text(isSelecting ? "Confirm Location" : (self.currentIndex == self.allLocations.count - 1 ? "View Results" : "Next Location"))
                        .foregroundColor(.white)
                        .padding([.vertical, .horizontal], 10)
                        .background(self.selectedPoint == nil ? Color(.systemGray) : Color(.systemPurple))
                        .cornerRadius(15)
                        .animation(.none)
                }
                .padding(.horizontal)
                .disabled(self.selectedPoint == nil)
            }
        }
        .onAppear {
            self.currentLocation = self.allLocations[self.currentIndex]
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
////        ContentView(totalScore: <#Binding<Int>#>)
//    }
//}
