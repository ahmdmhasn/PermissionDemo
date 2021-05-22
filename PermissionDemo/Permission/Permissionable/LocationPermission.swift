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
  private var onStatus: PermissionHandler?
  
  init(type: LocationPermissionType) {
    self.type = type
    self.locationManager = CLLocationManager()
    super.init()
    
    locationManager.delegate = self
  }
  
  func request(onStatus: @escaping PermissionHandler) {
    self.onStatus = onStatus

    guard CLLocationManager.locationServicesEnabled() else {
      return onStatus(.disabled)
    }

    switch type {
    case .always:
      locationManager.requestAlwaysAuthorization()
    case .whenInUse:
      locationManager.requestWhenInUseAuthorization()
    }
    
    locationManager.requestLocation()
  }
  
  func authorizationStatus(onStatus: @escaping PermissionHandler) {
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      onStatus(.authorized)
    case .denied, .restricted:
      onStatus(.denied)
    case .notDetermined:
      onStatus(.notDetermined)
    @unknown default:
      onStatus(.notDetermined)
    }
  }
}

// MARK: - CLLocationManagerDelegate
//
extension LocationPermission: CLLocationManagerDelegate {
    
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    authorizationStatus { [weak self] status in
      self?.onStatus?(status)
    }
  }
}
