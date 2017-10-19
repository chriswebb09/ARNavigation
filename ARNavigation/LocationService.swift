//
//  LocationService.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/18/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation


public class LocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var currentLocation: CLLocation?
    var initial: Bool = true
    var userHeading: CLLocationDirection!
    var locations: [CLLocation] = []
    
   public override init() {
        super.init()
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        requestAuthorization(locationManager: locationManager)
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    public func requestAuthorization(locationManager: CLLocationManager) {
        locationManager.requestWhenInUseAuthorization()
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation(locationManager: locationManager)
        case .denied, .notDetermined, .restricted:
            stopUpdatingLocation(locationManager: locationManager)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }
        
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
        NotificationCenter.default.post(name: Notification.Name(rawValue:"myNotificationName"), object: self, userInfo: nil)
    }
    
    public func startUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    public func stopUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            delegate?.trackingLocation(for: location)
        }
        currentLocation = manager.location
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    public func updateLocation(currentLocation: CLLocation) {
        guard let delegate = delegate else { return }
        delegate.trackingLocation(for: currentLocation)
    }
    
    public func updateLocationDidFailWithError(error: Error) {
        guard let delegate = delegate else { return }
        delegate.trackingLocationDidFail(with: error)
    }
}
