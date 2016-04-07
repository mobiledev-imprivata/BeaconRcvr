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
    func showNotification(message: String)
}

class BeaconManager: NSObject {
    
    private let proximityUUID = NSUUID(UUIDString: "0C9198B6-417B-4A9C-A5C4-2E2717C6E9C1")!
    private let major: CLBeaconMajorValue = 123
    private let minor: CLBeaconMinorValue = 456
    private let identifier = "com.imprivata.beaconxmtr"
    
    private var beaconRegion: CLBeaconRegion!
    private var locationManager: CLLocationManager!
    
    var delegate: BeaconManagerDelegate?
    
    func startMonitoring() {
        log("startMonitoring")
        
        guard beaconRegion == nil && locationManager == nil else {
            log("already monitoring")
            return
        }
        
        guard CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) else {
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
        locationManager.activityType = .Other
        locationManager.requestAlwaysAuthorization()
    }
    
    func stopMonitoring() {
        log("stopMonitoring")
        
        guard beaconRegion != nil && locationManager != nil else {
            log("already stopped")
            return
        }
        
        locationManager.stopMonitoringForRegion(beaconRegion)
        beaconRegion = nil
        locationManager = nil
    }
    
    private func startScanning() {
        log("startScanning")
        beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        locationManager.startMonitoringForRegion(beaconRegion)
        // locationManager.requestStateForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        log("locationManager didChangeAuthorizationStatus \(status.toString())")
        
        guard CLLocationManager.authorizationStatus()  == .AuthorizedAlways else {
            log("status is not AuthorizedAlways")
            return
        }
        
        startScanning()
    }
    
    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        log("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        log("locationManagerDidResumeLocationUpdates")
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        log("locationManager didStartMonitoringForRegion")
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        log("locationManager monitoringDidFailForRegion")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log("locationManager didEnterRegion")
        delegate?.showNotification("didEnterRegion")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        log("locationManager didExitRegion")
        delegate?.showNotification("didExitRegion")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        log("locationManager didDetermineState \(state.toString())")
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        log("locationManager didRangeBeacons \(beacons.count)")
        guard beacons.count > 0 else {
            log("no beacons found")
            return
        }
        log("proximity \(beacons[0].proximity.toString())")
    }
}

extension CLAuthorizationStatus {
    
    private func toString() -> String {
        switch self {
        case .NotDetermined: return "NotDetermined"
        case .Restricted: return "Restricted"
        case .Denied: return "Denied"
        case .AuthorizedAlways: return "AuthorizedAlways"
        case .AuthorizedWhenInUse: return "AuthorizedWhenInUse"
        }
    }
    
}

extension CLRegionState {
    
    private func toString() -> String {
        switch self {
        case .Unknown: return "Unknown"
        case .Inside: return "Inside"
        case .Outside: return "Outside"
        }
    }
    
}

extension CLProximity {
    
    private func toString() -> String {
        switch self {
        case .Unknown: return "Unknown"
        case .Immediate: return "Immediate"
        case .Near: return "Near"
        case .Far: return "Far"
        }
    }
    
}
