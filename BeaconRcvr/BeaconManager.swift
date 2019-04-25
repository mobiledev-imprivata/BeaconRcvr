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
    
    private let proximityUUID = UUID(uuidString: "2CAA4EDD-B1FD-411F-A02B-07393EAA6083")!
    private let identifier = "com.imprivata.beaconxmtr"
    
    private let numberOfBeaconRegions = 1
    private var beaconRegions = [CLBeaconRegion]()
    
    private var locationManager: CLLocationManager!

    var delegate: BeaconManagerDelegate?
    
    func startMonitoring() {
        log("startMonitoring")
        
        guard beaconRegions.isEmpty && locationManager == nil else {
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
        
        log("authorizationStatus \(CLLocationManager.authorizationStatus())")
        
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
        
        guard !beaconRegions.isEmpty && locationManager != nil else {
            log("already stopped")
            return
        }
        
        beaconRegions.forEach { locationManager.stopMonitoring(for: $0) }
        beaconRegions.removeAll()
        locationManager = nil
    }
    
    private func startScanning() {
        log("startScanning")
        
        for _ in 0..<numberOfBeaconRegions {
            // let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, identifier: identifier)
            let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: CLBeaconMajorValue(1), identifier: identifier)
            // let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
            beaconRegions.append(beaconRegion)
        }

        beaconRegions.forEach { locationManager.startMonitoring(for: $0) }

//        // beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, identifier: identifier)
//        beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, identifier: identifier)
//        // beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
//        locationManager.startMonitoring(for: beaconRegion)
        
        // locationManager.requestStateForRegion(beaconRegion)
        // locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        log("locationManager didChangeAuthorizationStatus \(status)")
        
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
        log("locationManager didStartMonitoringForRegion \(region.major)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log("locationManager didEnterRegion \(region.major)")
        delegate?.showNotification("didEnterRegion \(region.major)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        log("locationManager didExitRegion \(region.major)")
        delegate?.showNotification("didExitRegion \(region.major)")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        log("locationManager didDetermineState \(state) \(region.major)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        log("locationManager didRangeBeacons \(beacons.count)")
        guard beacons.count > 0 else {
            log("no beacons found")
            return
        }
        log("proximity \(beacons[0].proximity)")
    }

    // failures
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("locationManager didFailWithError \(error)")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        log("locationManager monitoringDidFailForRegion withError \(error)")
    }

}

extension CLAuthorizationStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        @unknown default: return "wtf!"
        }
    }

}

extension CLRegionState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .inside: return "inside"
        case .outside: return "outside"
        }
    }

}

extension CLProximity: CustomStringConvertible {

    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .immediate: return "immediate"
        case .near: return "near"
        case .far: return "far"
        @unknown default: return "wtf!"
        }
    }

}

extension CLRegion {
    
    var major: String {
        if let number = (self as? CLBeaconRegion)?.major {
            return "\(number)"
        }
        return "Ø"
    }
    
    var minor: String {
        if let number = (self as? CLBeaconRegion)?.minor {
            return "\(number)"
        }
        return "Ø"
    }
    
}
