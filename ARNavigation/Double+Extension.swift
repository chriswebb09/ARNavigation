//
//  Double+Extension.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/18/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

public extension Double {
    
    public func metersToLatitude() -> Double {
        return self / (6373000.0)
    }
    
    public func metersToLongitude() -> Double {
        return self / (5602900.0)
    }
    
    public func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    public func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
