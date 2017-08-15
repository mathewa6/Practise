//
//  DXLPointsOverlay.swift
//  Differential
//
//  Created by Adi Mathew on 7/20/17.
//  Copyright © 2017 RCPD. All rights reserved.
//

import UIKit
import MapKit

public class DXLPointsOverlay: NSObject, MKOverlay {
    
    public let origin: CLLocationCoordinate2D
    public let bottomRight: CLLocationCoordinate2D
    
    public var locations: [CLLocationCoordinate2D] = []
    
    public var coordinate: CLLocationCoordinate2D {
        guard let _: CLLocationCoordinate2D = self.locations.first else {
            return CLLocationCoordinate2D(latitude: 42.714543,
                                          longitude: -84.483931)
        }
        
        let midLatitude: CLLocationDegrees = (self.origin.latitude + self.bottomRight.latitude)/2.0
        let midLongitude: CLLocationDegrees = (self.origin.longitude + self.bottomRight.longitude)/2.0
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: midLatitude, longitude: midLongitude)
        
        guard CLLocationCoordinate2DIsValid(center) else {
            return self.origin
        }
        
        return center
    }
    
    public var boundingMapRect: MKMapRect {
        guard let _: CLLocationCoordinate2D = self.locations.first else {
            return MKMapRectNull
        }
        
        let coordinates: [CLLocationCoordinate2D] = [self.origin, self.bottomRight]
        let points: [MKMapPoint] = coordinates.map{ MKMapPointForCoordinate($0) }
        let rects: [MKMapRect] = points.map{ MKMapRect(origin: $0, size: MKMapSize(width: 0.0, height: 0.0)) }
        let boundingRect: MKMapRect = rects.reduce(MKMapRectNull,
                                                   MKMapRectUnion)
        
        
        return boundingRect
    }

    public init(withLocations locations: [CLLocationCoordinate2D]) {
        
        self.locations = locations
        
        var bboxarray: (minLat: Double, maxLat: Double, minLong: Double, maxLong: Double) = (
            Double.greatestFiniteMagnitude,
            -Double.greatestFiniteMagnitude,
            Double.greatestFiniteMagnitude,
            -Double.greatestFiniteMagnitude)
        
        // TODO: Add boundingBox to check intersection with mapRect in draw()
        
        for x in self.locations {
            let coordinate = x

            
            if coordinate.latitude < bboxarray.minLat { bboxarray.minLat = coordinate.latitude }
            else if coordinate.latitude > bboxarray.maxLat { bboxarray.maxLat = coordinate.latitude }
            
            if coordinate.longitude < bboxarray.minLong { bboxarray.minLong = coordinate.longitude }
            else if coordinate.longitude > bboxarray.maxLong { bboxarray.maxLong = coordinate.longitude }
            
        }
        
        self.origin = CLLocationCoordinate2D(latitude: bboxarray.maxLat,
                                             longitude: bboxarray.minLong)
        self.bottomRight = CLLocationCoordinate2D(latitude: bboxarray.minLat,
                                                  longitude: bboxarray.maxLong)
        
        super.init()

    }
}
