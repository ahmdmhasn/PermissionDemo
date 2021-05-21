//
//  LocationPermission.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import Foundation
import CoreLocation

enum LocationPermissionType {
  case always
  case whenInUse
}

// MARK: - LocationPermission - Used to get/ request location permission
//
class LocationPermission: NSObject, Permissionable {
  
  let locationManager: CLLocationManager
  let type: LocationPermissionType
  private var onStatus: ((PermissionStatus) -> Void)?
  
  init(type: LocationPermissionType) {
    self.type = type
    self.locationManager = CLLocationManager()
  }
  
  func request(onStatus: @escaping ((PermissionStatus) -> Void)) {
    self.onStatus = onStatus
    
    switch type {
    case .always:
      locationManager.requestAlwaysAuthorization()
    case .whenInUse:
      locationManager.requestWhenInUseAuthorization()
    }
    
    guard CLLocationManager.locationServicesEnabled() else {
      return onStatus(.disabled)
    }

    locationManager.delegate = self
    locationManager.requestLocation()
  }
  
  func authorizationStatus(onStatus: @escaping ((PermissionStatus) -> Void)) {
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      onStatus(.authorized)
    case .denied, .restricted:
      onStatus(.denied)
    case .notDetermined:
      onStatus(.notDetermined)
    default:
      onStatus(.notDetermined)
    }
  }
}

// MARK: - CLLocationManagerDelegate
//
extension LocationPermission: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    onStatus?(.authorized)
    locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    onStatus?(.denied)
    locationManager.stopUpdatingLocation()
  }
}
