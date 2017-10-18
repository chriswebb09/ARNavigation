//
//  CLLocation+Extension.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/18/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
   public func bearingToLocationRadian(_ destinationLocation: CLLocation) -> Double {
        
        let lat1 = self.coordinate.latitude.toRadians()
        let lon1 = self.coordinate.longitude.toRadians()
        
        let lat2 = destinationLocation.coordinate.latitude.toRadians()
        let lon2 = destinationLocation.coordinate.longitude.toRadians()
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)
        return radiansBearing
    }
}
