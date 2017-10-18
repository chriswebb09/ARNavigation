//
//  SCNVector3+Extension.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/18/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    public func distance(to vector: SCNVector3) -> Float {
        return sqrt(pow(vector.x - x, 2) + pow(vector.z - z, 2))
    }
    
    public static func positionFrom(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
}
