//
//  MappingService.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ARKit

public class MappingService {
    
    public var startingLocation: CLLocation!
    
    public var destinationLocation: CLLocationCoordinate2D! {
        didSet {
            setupNavigation()
        }
    }
    
    public var annotationColor = UIColor.blue
    
    public var mapView: MKMapView!
    public var annotations: [Annotation] = []
    
    public var navigationService: NavigationService = NavigationService()
    
    public var steps: [MKRouteStep] = []
    public var currentTripLegs: [[CLLocationCoordinate2D]] = []
    public var locations: [CLLocation] = []
    
    public func setupNavigation() {
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .default).async {
            
            if self.destinationLocation != nil {
                self.navigationService.getDirections(destinationLocation: self.destinationLocation, request: MKDirectionsRequest()) { steps in
                    for step in steps {
                        self.annotations.append(Annotation(coordinate: step.getLocation().coordinate, name: "N " + step.instructions))
                    }
                    self.steps.append(contentsOf: steps)
                    group.leave()
                }
            }
            
            // All steps must be added before moving to next step
            
            group.wait()
            
            self.getLocationData()
        }
    }
    
    public func getLocationData() {
        
        for (index, step) in steps.enumerated() {
            setTripLegFromStep(step, and: index)
        }
        
        for leg in currentTripLegs {
            update(intermediary: leg)
        }
        
        centerMapInInitialCoordinates()
        showPointsOfInterestInMap(currentTripLegs: currentTripLegs)
        addMapAnnotations()
    }
    
    public func setTripLegFromStep(_ tripStep: MKRouteStep, and index: Int) {
        if index > 0 {
            getTripLeg(for: index, and: tripStep)
        } else {
            getInitialLeg(for: tripStep)
        }
    }
    
    
    public func getInitialLeg(for tripStep: MKRouteStep) {
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: startingLocation, destinationLocation: nextLocation)
        currentTripLegs.append(intermediaries)
    }
    
    public func getTripLeg(for index: Int, and tripStep: MKRouteStep) {
        let previousIndex = index - 1
        let previousStep = steps[previousIndex]
        let previousLocation = CLLocation(latitude: previousStep.polyline.coordinate.latitude, longitude: previousStep.polyline.coordinate.longitude)
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediarySteps = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previousLocation, destinationLocation: nextLocation)
        currentTripLegs.append(intermediarySteps)
    }
    
    public func update(intermediary locations: [CLLocationCoordinate2D]) {
        for intermediaryLocation in locations {
            annotations.append(Annotation(coordinate: intermediaryLocation, name: String(describing:intermediaryLocation)))
            self.locations.append(CLLocation(latitude: intermediaryLocation.latitude, longitude: intermediaryLocation.longitude))
        }
    }
    
    public func showPointsOfInterestInMap(currentTripLegs: [[CLLocationCoordinate2D]]) {
        mapView.removeAnnotations(mapView.annotations)
        for tripLeg in currentTripLegs {
            for coordinate in tripLeg {
                let poi = Annotation(coordinate: coordinate, name: String(describing: coordinate))
                mapView.addAnnotation(poi)
            }
        }
    }
    
    public func centerMapInInitialCoordinates() {
        if startingLocation != nil {
            DispatchQueue.main.async {
                self.mapView.setCenter(self.startingLocation.coordinate, animated: true)
                let latDelta: CLLocationDegrees = 0.004
                let lonDelta: CLLocationDegrees = 0.004
                let span = MKCoordinateSpanMake(latDelta, lonDelta)
                let region = MKCoordinateRegionMake(self.startingLocation.coordinate, span)
                self.mapView.setRegion(region, animated: false)
            }
        }
    }
    
    public func addMapAnnotations() {
        
        annotations.forEach { annotation in
            
            // Step annotations are green, intermediary are blue
            DispatchQueue.main.async {
                if let title = annotation.title, title.hasPrefix("N") {
                    self.annotationColor = .green
                } else {
                    self.annotationColor = .blue
                }
                self.mapView?.addAnnotation(annotation)
                self.mapView.add(MKCircle(center: annotation.coordinate, radius: 0.2))
            }
        }
    }
}

