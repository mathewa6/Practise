import UIKit
import PlaygroundSupport
import MapKit


let vc: GPXViewController = GPXViewController()
PlaygroundPage.current.liveView = vc

let points = vc.testCoordinates
let overlay = DXLPointsOverlay(withLocations: points)
let drend = DXLPointsRenderer(overlay: overlay)
let mapv = vc.mapView

var plotPoints: [CGPoint] = []

func viewmage() {
    let rect = CGRect(x: 0, y: 0, width: 512, height: 512)
    let view = UIView(frame: rect)
    
    for point in points {
        let x = mapv?.convert(point, toPointTo: view)
        plotPoints.append(x!)
    }
}

func drawmage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512,
                                                        height: 512))
    let image = renderer.image { (context: UIGraphicsImageRendererContext) in
        let ctx: CGContext = context.cgContext
        ctx.setFillColor(UIColor.red.cgColor)
        
        for location in plotPoints {
            let rect = CGRect(x: location.x, y: location.y, width: 3.0, height: 3.0)
            ctx.setLineWidth(3.0)
            
            ctx.addEllipse(in: rect)
            ctx.fillEllipse(in: rect)
            
        }
    }
    
    return image
}

func drawRect() -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512,
                                                        height: 512))
    let image = renderer.image { (context: UIGraphicsImageRendererContext) in
        let ctx: CGContext = context.cgContext
        ctx.setFillColor(UIColor.red.cgColor)
                
        for location in points {
            
            let color: CGColor = UIColor.cyan.cgColor
            
            let point: CGPoint = location.cgPoint(usingOverlayRenderer: drend)
            
            let radius: CGFloat = 5.4
            let dimensions: CGFloat = radius * pow(1/8, -1)
            let origin: CGPoint = CGPoint(x: point.x - dimensions, y: point.y - dimensions)
            
            let rect = CGRect(origin: origin, size: CGSize(width: 2 * dimensions,
                                                           height: 2 * dimensions))
            
            ctx.setLineWidth(dimensions)
            ctx.setStrokeColor(color)
            ctx.setFillColor(color)
            
            ctx.addEllipse(in: rect)
            ctx.strokeEllipse(in: rect)
            ctx.fillEllipse(in: rect)
            
        }
    }
    
    return image
}

