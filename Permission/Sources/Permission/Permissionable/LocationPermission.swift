//
//  LocationPermission.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import Foundation
import CoreLocation

// MARK: - LocationPermissionType
//
public enum LocationPermissionType {
  
  /// Location services regardless of whether the app is in use.
  ///
  case always
  
  /// Location services while the app is in use.
  ///
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
  
  var configuration: Configuration {
    return ConfigurationWrapper(
      title: "Allow access to your location",
      message: "We use your location to show local content, improve recommendations, and more."
    )
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
