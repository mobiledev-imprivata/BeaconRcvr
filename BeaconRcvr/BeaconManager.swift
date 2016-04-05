//
//  BeaconManager.swift
//  BeaconRcvr
//
//  Created by Jay Tucker on 4/5/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManager: NSObject {
    
    private let proximityUUID = NSUUID(UUIDString: "0C9198B6-417B-4A9C-A5C4-2E2717C6E9C1")!
    private let major: CLBeaconMajorValue = 123
    private let minor: CLBeaconMinorValue = 456
    private let identifier = "com.imprivata.beaconxmtr"
    
    private var beaconRegion: CLBeaconRegion!
    private var locationManager: CLLocationManager!
    
    func startMonitoring() {
        print("startMonitoring")
        
        guard beaconRegion == nil && locationManager == nil else {
            print("already monitoring")
            return
        }
        
        guard CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) else {
            print("monitoring is not available for CLBeaconRegion")
            return
        }
        
        guard CLLocationManager.isRangingAvailable() else {
            print("ranging is not available for CLBeaconRegion")
            return
        }
        
        print("authorizationStatus \(CLLocationManager.authorizationStatus().toString())")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.activityType = CLActivityType.Other
        locationManager.requestAlwaysAuthorization()
    }
    
    func stopMonitoring() {
        print("stopMonitoring")
        
        guard beaconRegion != nil && locationManager != nil else {
            print("already stopped")
            return
        }

        locationManager.stopMonitoringForRegion(beaconRegion)
        beaconRegion = nil
        locationManager = nil
    }
    
    private func startScanning() {
        print("startScanning")
        beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        locationManager.startMonitoringForRegion(beaconRegion)
    }
    
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("locationManager didChangeAuthorizationStatus \(status.toString())")
        
        guard CLLocationManager.authorizationStatus()  == .AuthorizedAlways else {
            print("status is not AuthorizedAlways")
            return
        }
        
        startScanning()
    }
    
    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("locationManager didStartMonitoringForRegion")
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("locationManager monitoringDidFailForRegion")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("locationManager didEnterRegion")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("locationManager didExitRegion")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        print("locationManager didDetermineState \(state.toString())")
    }
    
}

extension CLAuthorizationStatus {
    
    func toString() -> String {
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

    func toString() -> String {
        switch self {
        case .Unknown: return "Unknown"
        case .Inside: return "Inside"
        case .Outside: return "Outside"
        }
    }
    
}