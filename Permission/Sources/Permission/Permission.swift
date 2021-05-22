//
//  Permission.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import UIKit
import AVFoundation

// MARK: - PermissionStatus - Represents valid permission status values
//
public enum PermissionStatus {
  
  /// User authories access
  ///
  case authorized
  
  /// User denied permission
  ///
  case denied
  
  /// Unable to find the required type
  ///
  case disabled
  
  /// Unable to determine current state
  ///
  case notDetermined
}

// MARK: - PermissionType - Avaiable permission types to be requested
//
public enum PermissionType {
  
  /// Notifications
  ///
  case notification(options: UNAuthorizationOptions = [])
  
  /// Camera, Used for photo and video
  ///
  case camera
  
  /// Location. We can request even always or when in use
  ///
  case location(locationType: LocationPermissionType)
}

// MARK: - Permission
//
public struct Permission {
  
  public typealias Configuration = PermissionDialog.Configuration
  
  /// PermissionType
  ///
  let type: PermissionType
  
  /// PermissionDialog - Responsible for settinga and permission alerts
  ///
  let dialog: PermissionDialog
  
  /// Init
  ///
  public init(presenter: UIViewController,
              type: PermissionType,
              configuration: Configuration = Configuration()) {
    self.type = type
    self.dialog = PermissionDialog(presenter: presenter, configuration: configuration)
  }
  
  /// Permissionable
  ///
  private var permissionable: Permissionable {
    switch type {
    case .notification(let options):
      return NotificationPermission(options: options)
      
    case .camera:
      return CameraPermission()
      
    case .location(let locationType):
      return LocationPermission(type: locationType)
    }
  }
  
  /// Request permission.
  /// `onStatus` will be called with the `PermissionStatus` type
  ///
  public func request(onStatus: @escaping ((PermissionStatus) -> Void)) {
    
    func onStatusOnMainQueue(_ status: PermissionStatus) {
      DispatchQueue.main.async {
        onStatus(status)
      }
    }
    
    permissionable.authorizationStatus { status in
      switch status {
      case .authorized, .disabled:
        onStatusOnMainQueue(status)

      case .denied:
        dialog.showSettingsAlert()
        onStatusOnMainQueue(.denied)
        
      case .notDetermined:
        dialog.showPermissionAlert {
          permissionable.request(onStatus: onStatusOnMainQueue)
        }
      }
    }
  }
}
