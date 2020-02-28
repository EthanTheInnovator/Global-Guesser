//
//  MapView.swift
//  GlobalGuesser
//
//  Created by Ethan Humphrey on 1/7/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var currentLocation: Location
    @Binding var isSelecting: Bool
    @Binding var selectedPoint: CLLocationCoordinate2D?
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        let gestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.recognizedPress(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.showsScale = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let hadSingleAnnotation = uiView.annotations.count == 1
        let hadAnyAnnotations = uiView.annotations.count > 0
        uiView.removeAnnotations(uiView.annotations)
        if selectedPoint != nil {
            uiView.addAnnotation(MKPointAnnotation(from: selectedPoint!, named: "Your Guess"))
        }
        if !isSelecting {
            uiView.addAnnotation(MKPointAnnotation(from: currentLocation.coordinate, named: currentLocation.name))
            if hadSingleAnnotation {
                uiView.showAnnotations(uiView.annotations, animated: true)
            }
        }
        if hadAnyAnnotations && uiView.annotations.count == 0 {
            let region = MKCoordinateRegion(center: uiView.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180))
            uiView.setRegion(region, animated: true)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        
        @Binding var isEditable: Bool
        @Binding var selectedPoint: CLLocationCoordinate2D?
        
        init(isEditable: Binding<Bool>, selectedPoint: Binding<CLLocationCoordinate2D?>) {
            _isEditable = isEditable
            _selectedPoint = selectedPoint
        }
        
        @objc func recognizedPress(_ gesture: UIGestureRecognizer) {
            if isEditable {
                let mapView = gesture.view as! MKMapView
                let location = gesture.location(in: mapView)
                selectedPoint = mapView.convert(location, toCoordinateFrom: mapView)
                
                print(selectedPoint)
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if selectedPoint != nil {
                if annotation.coordinate == selectedPoint! {
                    let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "userAnnotation")
                    markerView.markerTintColor = .systemPurple
                    return markerView
                }
            }
            let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "otherAnnotation")
            markerView.markerTintColor = .systemGreen
            markerView.glyphImage = UIImage(systemName: "star.fill")
            return markerView
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isEditable: $isSelecting, selectedPoint: $selectedPoint)
    }
}

//class MapViewDelegate: NSObject, MKMapViewDelegate {
//    var mapView: MKMapView!
//    var isEditable: Bool!
//    func recognizedLongPress(_ gesture: UILongPressGestureRecognizer) {
//
//    }
//}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
////        MapView(annotations: [], isEditable: )
//    }
//}
