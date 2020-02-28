//
//  Location.swift
//  GlobalGuesser
//
//  Created by Ethan Humphrey on 1/7/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct Location {
    var name: String
    var image: Image
    var coordinate: CLLocationCoordinate2D
    
    static func getAllLocations() -> [Location] {
        return [
            Location(name: "My Old House, St. David's, Bermuda", image: Image("location0"), coordinate: CLLocationCoordinate2D(latitude: 32.370349, longitude: -64.655649)),
            Location(name: "Whistler Blackcomb Mountain, Canada", image: Image("location1"), coordinate: CLLocationCoordinate2D(latitude: 50.114846, longitude: -122.948646)),
            Location(name: "Morristown Green, New Jersey", image: Image("location2"), coordinate: CLLocationCoordinate2D(latitude: 40.797027, longitude: -74.481013)),
            Location(name: "Park City, Utah", image: Image("location3"), coordinate: CLLocationCoordinate2D(latitude: 40.651328, longitude: -111.507882)),
            Location(name: "McEnery Convention Center, San Jose, California", image: Image("location4"), coordinate: CLLocationCoordinate2D(latitude: 37.329788, longitude: -121.889194)),
            Location(name: "Raleigh, North Carolina", image: Image("location5"), coordinate: CLLocationCoordinate2D(latitude: 35.769670, longitude: -78.570078)),
            Location(name: "Oklahoma City, Oklahoma", image: Image("location6"), coordinate: CLLocationCoordinate2D(latitude: 35.491522, longitude: -97.588256)),
            Location(name: "World of Coke, Atlanta, Georgia", image: Image("location7"), coordinate: CLLocationCoordinate2D(latitude: 33.762869, longitude: -84.392670)),
            Location(name: "Cape Canaveral, Florida", image: Image("location8"), coordinate: CLLocationCoordinate2D(latitude: 28.561593, longitude: -80.577251)),
            Location(name: "Disney's Castaway Cay, The Bahamas", image: Image("location9"), coordinate: CLLocationCoordinate2D(latitude: 26.093663, longitude: -77.533795)),
            Location(name: "Cancun, Mexico", image: Image("location10"), coordinate: CLLocationCoordinate2D(latitude: 21.164126, longitude: -86.85298))
        ]
    }
}

extension MKPointAnnotation {
    convenience init(from coordinate: CLLocationCoordinate2D, named title: String? = nil) {
        self.init()
        self.coordinate = coordinate
        self.title = title
    }
}

extension CLLocationCoordinate2D {
    static func == (cord1: CLLocationCoordinate2D, cord2: CLLocationCoordinate2D) -> Bool {
        return (cord1.latitude == cord2.latitude) && (cord1.longitude == cord2.longitude)
    }
    func distance(from coordinate: CLLocationCoordinate2D) -> Double {
        let thisLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let otherLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = thisLocation.distance(from: otherLocation)
        return distance.magnitude / 1000
    }
}
