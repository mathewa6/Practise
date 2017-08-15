//
//  DXLDebugTileOverlay.swift
//  Differential
//
//  Created by Adi Mathew on 8/14/17.
//  Copyright © 2017 RCPD. All rights reserved.
//

import UIKit
import MapKit

class DXLDebugTileOverlayRenderer: MKTileOverlayRenderer {
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        super.draw(mapRect, zoomScale: zoomScale, in: context)
        
        let rect: CGRect = self.rect(for: mapRect)
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
    }
    
}
