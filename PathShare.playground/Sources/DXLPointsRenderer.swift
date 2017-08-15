//
//  DXLPointsRenderer.swift
//  Differential
//
//  Created by Adi Mathew on 7/20/17.
//  Copyright © 2017 RCPD. All rights reserved.
//

import UIKit
import MapKit


public extension CLLocationCoordinate2D {
    func cgPoint(usingOverlayRenderer renderer: MKOverlayRenderer) -> CGPoint {
        let mapPoint: MKMapPoint = MKMapPointForCoordinate(self)
        
        return renderer.point(for: mapPoint)
    }
}

public class DXLPointsRenderer: MKOverlayRenderer {
    
    private let pointsOverlay: DXLPointsOverlay


    public var locations: [CLLocationCoordinate2D] {
        return self.pointsOverlay.locations
    }
    
    public override init(overlay: MKOverlay) {

        self.pointsOverlay = overlay as! DXLPointsOverlay
        super.init(overlay: overlay)
        
    }
    
    override public func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
        for location in self.pointsOverlay.locations {
            
            let color: CGColor = UIColor.cyan.cgColor
            
            let point: CGPoint = location.cgPoint(usingOverlayRenderer: self)
            
            let radius: CGFloat = 9
            let dimensions: CGFloat = radius * pow(zoomScale, -1)
            let origin: CGPoint = CGPoint(x: point.x - dimensions, y: point.y - dimensions)
            
            let rect = CGRect(origin: origin, size: CGSize(width: 2 * dimensions,
                                                           height: 2 * dimensions))
            
            context.setLineWidth(dimensions)
            context.setStrokeColor(color)
            context.setFillColor(color)
            
            context.addEllipse(in: rect)
            context.strokeEllipse(in: rect)
            context.fillEllipse(in: rect)
            
        }
        
        
        // let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // let image = UIImage(cgImage: context.makeImage()!)
        // print(image)
        
    }
}
