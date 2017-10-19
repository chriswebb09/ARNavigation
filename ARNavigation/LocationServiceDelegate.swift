//
//  LocationServiceDelegate.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    func trackingLocation(for currentLocation: CLLocation)
    func trackingLocationDidFail(with error: Error)
}

