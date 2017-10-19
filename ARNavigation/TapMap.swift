//
//  TapMap.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

open class TapMap: MKMapView {
    
    private var press: UILongPressGestureRecognizer!
    
    public var destinationLocation: CLLocationCoordinate2D!
    
    public init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setup() {
        press = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(gesture:)))
        press.minimumPressDuration = 0.35
        addGestureRecognizer(press)
    }
    
    @objc private func handleMapTap(gesture: UIGestureRecognizer) {
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
