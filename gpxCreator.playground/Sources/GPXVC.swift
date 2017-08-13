import UIKit
import MapKit

public class GPXViewController: UIViewController {
    
    private var mapView: MKMapView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let frame: CGRect = CGRect(x: 0.0,
                                   y: 0.0,
                                   width: 375.0,
                                   height: 375.0)
        let mainView: UIView = UIView(frame: frame)
        
        
        self.mapView = MKMapView(frame: frame)
        mainView.addSubview(self.mapView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(mapTapped(_:)))
        
        self.mapView.addGestureRecognizer(tap)
        
        self.view = mainView
        self.view.backgroundColor = .white
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let mapCenterCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.725680140945656, longitude: -84.477848661018569)
        
        
        let mapCamera: MKMapCamera = MKMapCamera(lookingAtCenter: mapCenterCoordinate,
                                                 fromDistance: 9000.0,
                                                 pitch: 0,
                                                 heading: 0)
        let newMapCamera: MKMapCamera = MKMapCamera(lookingAtCenter: mapCenterCoordinate,
                                                    fromDistance: 6000.0,
                                                    pitch: 0,
                                                    heading: 0)
        
        self.mapView.camera = mapCamera
        UIView.animate(withDuration: 3.0, delay: 3.0, options: [.allowUserInteraction, .curveEaseInOut], animations: { self.mapView.camera = newMapCamera }, completion: nil)
    }
    
    
    func mapTapped(_ gesture: UITapGestureRecognizer) {
        let touchPoint: CGPoint = gesture.location(in: self.mapView)
        let touchCoordinate: CLLocationCoordinate2D = self.mapView.convert(touchPoint,
                                                                           toCoordinateFrom: self.mapView)
        print(touchCoordinate)
        print(self.mapView.camera.altitude)
    }
}
