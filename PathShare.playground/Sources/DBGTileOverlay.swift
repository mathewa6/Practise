//
//  DBGTileOverlay.swift
//  
//
//  Created by Adi Mathew on 8/15/17.
//
//

import UIKit
import MapKit

class DBGTileOverlay: MKTileOverlay {
    private func tileString(forTilePath path: MKTileOverlayPath) -> String {
        return "\(path.z)/\(path.y)/\(path.x)"
    }
    
    private func arcgisURL(forTilePath path: MKTileOverlayPath) -> URL? {
        var baseURLString: String = "https://fis.ipf.msu.edu/agsprod01/rest/services/Basemaps/MSUTiled/MapServer/tile/"
        baseURLString.append(self.tileString(forTilePath: path))
        
        return URL(string: baseURLString)
    }
    
    
    /**
     
     Overrides the MKTileOverlay implementation to limit zoom as well as use a cache.
     
     - Parameters:
     - path: Path structure to identify the exact tile. URL based on it is used as key into cache
     - result: Completion block to call when tile is fetched.
     
     */
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        
        guard path.z <= 21 else {
            return
        }
        
        guard let url: URL = self.arcgisURL(forTilePath: path) else {
            return
        }
        
        let cachePathComponents: String = self.tileString(forTilePath: path)
        
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if (error != nil) {
                    // TODO: Check for (Error Domain=NSURLErrorDomain Code=-1001 \"The request timed out.\
                    
                    debugPrint("TILE ERROR:", error.debugDescription)
                    return
                }
                               result(data, error)
                
                }.resume()
        }
    }

