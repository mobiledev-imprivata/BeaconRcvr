//
//  BeaconManager.swift
//  BeaconRcvr
//
//  Created by Jay Tucker on 4/5/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconManagerDelegate {
    func showNotification(_ message: String)
}

final class BeaconManager: NSObject {
    
    fileprivate let proximityUUID = UUID(uuidString: "0C9198B6-417B-4A9C-A5C4-2E2717C6E9C1")!
    fileprivate let major: CLBeaconMajorValue = 123
    fileprivate let minor: CLBeaconMinorValue = 456
    fileprivate let identifier = "com.imprivata.beaconxmtr"
    
    fileprivate var beaconRegion: CLBeaconRegion!
    fileprivate var locationManager: CLLocationManager!
    
    var delegate: BeaconManagerDelegate?
    
    func startMonitoring() {
        log("startMonitoring")
        
        guard beaconRegion == nil && locationManager == nil else {
            log("already monitoring")
            return
        }
        
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else {
            log("monitoring is not available for CLBeaconRegion")
            return
        }
        
        guard CLLocationManager.isRangingAvailable() else {
            log("ranging is not available for CLBeaconRegion")
            return
        }
        
        log("authorizationStatus \(CLLocationManager.authorizationStatus().toString())")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.activityType = .other
        // locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        log("end of startMonitoring")
    }
    
    func stopMonitoring() {
        log("stopMonitoring")
        
        guard beaconRegion != nil && locationManager != nil else {
            log("already stopped")
            return
        }
        
        locationManager.stopMonitoring(for: beaconRegion)
        beaconRegion = nil
        locationManager = nil
    }
    
    fileprivate func startScanning() {
        log("startScanning")
        // beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, identifier: identifier)
        locationManager.startMonitoring(for: beaconRegion)
        // locationManager.requestStateForRegion(beaconRegion)
        // locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        log("locationManager didChangeAuthorizationStatus \(status.toString())")
        
        guard CLLocationManager.authorizationStatus()  == .authorizedAlways else {
            log("status is not AuthorizedAlways")
            return
        }
        
        startScanning()
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        log("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        log("locationManagerDidResumeLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        log("locationManager didStartMonitoringForRegion")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log("locationManager didEnterRegion")
        delegate?.showNotification("didEnterRegion")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        log("locationManager didExitRegion")
        delegate?.showNotification("didExitRegion")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        log("locationManager didDetermineState \(state.toString())")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        log("locationManager didRangeBeacons \(beacons.count)")
        guard beacons.count > 0 else {
            log("no beacons found")
            return
        }
        log("proximity \(beacons[0].proximity.toString())")
    }

    // failures
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("locationManager didFailWithError \(error)")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        log("locationManager monitoringDidFailForRegion withError \(error)")
    }

}

extension CLAuthorizationStatus {
    
    fileprivate func toString() -> String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        }
    }
    
}

extension CLRegionState {
    
    fileprivate func toString() -> String {
        switch self {
        case .unknown: return "unknown"
        case .inside: return "inside"
        case .outside: return "outside"
        }
    }
    
}

extension CLProximity {
    
    fileprivate func toString() -> String {
        switch self {
        case .unknown: return "unknown"
        case .immediate: return "immediate"
        case .near: return "near"
        case .far: return "far"
        }
    }
    
}
