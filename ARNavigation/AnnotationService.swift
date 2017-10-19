//
//  AnnotationService.swift
//  ARNavigation
//
//  Created by Christopher Webb-Orenstein on 10/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ARKit

open class AnnotationService {
    
    var startingLocation: CLLocation!
    var sceneView: ARSCNView!
    var nodes: [BaseNode]!
    var anchors: [ARAnchor]!
    var updateNodes: Bool!
    var locationUpdates: Int = 0
    var updatedLocations: [CLLocation]!
    
    private func addSphere(for step: MKRouteStep) {
        DispatchQueue.main.async {
            let stepLocation = step.getLocation()
            let locationTransform = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: self.startingLocation, location: stepLocation)
            let stepAnchor = ARAnchor(transform: locationTransform)
            let sphere = BaseNode(title: step.instructions, location: stepLocation)
            self.anchors.append(stepAnchor)
            
            sphere.addNode(with: 0.3, and: .green, and: step.instructions)
            sphere.location = stepLocation
            sphere.anchor = stepAnchor
            self.sceneView.session.add(anchor: stepAnchor)
            self.sceneView.scene.rootNode.addChildNode(sphere)
            self.nodes.append(sphere)
        }
        
    }
    
    // For intermediary locations - CLLocation - add sphere
    
    private func addSphere(for location: CLLocation) {
        DispatchQueue.main.async {
            let locationTransform = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: self.startingLocation, location: location)
            let stepAnchor = ARAnchor(transform: locationTransform)
            let sphere = BaseNode(title: "Title", location: location)
            
            sphere.addSphere(with: 0.25, and: .blue)
            self.anchors.append(stepAnchor)
            sphere.location = location
            self.sceneView.session.add(anchor: stepAnchor)
            self.sceneView.scene.rootNode.addChildNode(sphere)
            sphere.anchor = stepAnchor
            self.nodes.append(sphere)
        }
    }
    
    
    private func updateNodePosition() {
        if updateNodes {
            locationUpdates += 1
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            if updatedLocations.count > 0 {
                startingLocation = CLLocation.bestLocationEstimate(locations: updatedLocations)
                for baseNode in nodes {
                    let translation = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: baseNode.location)
                    let position = SCNVector3.positionFrom(translation)
                    let distance = baseNode.location.distance(from: startingLocation)
                    DispatchQueue.main.async {
                        let scale = 100 / Float(distance)
                        baseNode.scale = SCNVector3(x: scale, y: scale, z: scale)
                        baseNode.anchor = ARAnchor(transform: translation)
                        baseNode.position = position
                    }
                }
            }
            SCNTransaction.commit()
        }
    }
    
}
