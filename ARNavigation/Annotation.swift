//
//  Annotation.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import MapKit

open class Annotation: NSObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D
    
    public var title: String?
    
    public var subtitle: String?
    
    public init(coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = coordinate
        self.title = name
        self.subtitle =  "(\(coordinate.latitude),\(coordinate.longitude))"
        super.init()
    }
}
