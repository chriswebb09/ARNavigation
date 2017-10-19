//
//  LocationTranslation.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

public struct LocationTranslation {
    public var latitudeTranslation: Double
    public var longitudeTranslation: Double
    public var altitudeTranslation: Double
    
    public init(latitudeTranslation: Double, longitudeTranslation: Double, altitudeTranslation: Double) {
        self.latitudeTranslation = latitudeTranslation
        self.longitudeTranslation = longitudeTranslation
        self.altitudeTranslation = altitudeTranslation
    }
}
