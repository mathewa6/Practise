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
        let locations = self.pointsOverlay.locations
        let color: CGColor = UIColor.cyan.cgColor

        if pow(zoomScale, -1) < 8 {
        
            for location in locations {
                
                
                let point: CGPoint = location.cgPoint(usingOverlayRenderer: self)
                
                let radius: CGFloat = 15
                let factor: CGFloat = pow(zoomScale, -1)
                let dimensions: CGFloat = radius * factor
                let origin: CGPoint = CGPoint(x: point.x - dimensions, y: point.y - dimensions)
                
                let rect = CGRect(origin: origin, size: CGSize(width: 2 * dimensions,
                                                               height: 2 * dimensions))
                
                context.setLineWidth(dimensions)
                context.setStrokeColor(color)
                context.setFillColor(color)
                context.addEllipse(in: rect)

                context.setShadow(offset: CGSize(width: -300, height: 90), blur: 120.0, color: UIColor.black.cgColor)

                context.strokeEllipse(in: rect)
                context.fillEllipse(in: rect)
                
                
                
            }
            
        } else {
            let path: CGMutablePath = CGMutablePath()

            for (i, location) in locations.enumerated() {
                let mapPoint: MKMapPoint = MKMapPointForCoordinate(location)
                let point: CGPoint = self.point(for: mapPoint)
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    let previousMapPoint: MKMapPoint = MKMapPointForCoordinate(locations[i-1])
                    let previous: CGPoint = self.point(for: previousMapPoint)
                    
                    // path.move(to: previous)
                    path.addLine(to: point)
                }

                
                
            }
            
            let radius: CGFloat = 15
            let dimensions: CGFloat = radius * pow(zoomScale, -1)
            
            context.setLineWidth(dimensions)
            context.setLineJoin(.round)
            context.setLineCap(.round)
            context.setStrokeColor(color)
            context.setShadow(offset: CGSize(width: -21, height: 30), blur: 45.0, color: UIColor.black.cgColor)
            context.addPath(path)
            
            context.strokePath()
        }
        
        // let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // let image = UIImage(cgImage: context.makeImage()!)
        // print(image)
        
    }
}
