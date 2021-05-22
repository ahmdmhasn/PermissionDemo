//
//  CameraPermission.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import Foundation
import AVFoundation

// MARK: - CameraPermission - Used to get/ request camera permission
//
struct CameraPermission: Permissionable {
    
  var configuration: Configuration {
    return ConfigurationWrapper(
      title: "Allow access to your camera",
      message: "We use your camera to take images, and more."
    )
  }

  func request(onStatus: @escaping PermissionHandler) {
    AVCaptureDevice.requestAccess(for: .video) { allowed in
      onStatus(allowed ? .authorized : .denied)
    }
  }
  
  func authorizationStatus(onStatus: @escaping PermissionHandler) {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .authorized:
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
