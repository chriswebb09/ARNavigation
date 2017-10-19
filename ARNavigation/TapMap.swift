//
//  TapMap.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

open class TapMap: MKMapView {
    
    public var press: UILongPressGestureRecognizer!
    
    public var destinationLocation: CLLocationCoordinate2D!
    
    public func setup() {
        press = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(gesture:)))
        press.minimumPressDuration = 0.35
        addGestureRecognizer(press)
    }
    
    @objc public func handleMapTap(gesture: UIGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        // Get tap point on map
        let touchPoint = gesture.location(in: self)
        
        // Convert map tap point to coordinate
        let coord: CLLocationCoordinate2D = convert(touchPoint, toCoordinateFrom: self)
        
        destinationLocation = coord
    }
}
