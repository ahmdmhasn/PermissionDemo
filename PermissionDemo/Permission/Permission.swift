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
enum PermissionStatus {
  
  /// User authories access
  ///
  case authorized
  
  /// User denied permission
  ///
  case denied
  
  /// Unable to determine current state
  ///
  case notDetermined
}

// MARK: - PermissionType - Avaiable permission types to be requested
//
enum PermissionType {
  
  /// Notifications
  ///
  case notification(options: UNAuthorizationOptions = [])
  
  /// Camera, Used for photo and video
  ///
  case camera
}

// MARK: - Permission
//
struct Permission {
  
  typealias Configuration = PermissionDialog.Configuration
  
  /// PermissionType
  ///
  let type: PermissionType
  
  /// PermissionDialog - Responsible for settinga and permission alerts
  ///
  let dialog: PermissionDialog
  
  /// Init
  ///
  init(presenter: UIViewController, type: PermissionType, configuration: Configuration = Configuration()) {
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
    }
  }
  
  /// Request permission.
  /// `onStatus` will be called with the `PermissionStatus` type
  ///
  func request(onStatus: @escaping ((PermissionStatus) -> Void)) {
    
    func onStatusOnMainQueue(_ status: PermissionStatus) {
      DispatchQueue.main.async {
        onStatus(status)
      }
    }
    
    permissionable.checkStatus { status in
      switch status {
      case .authorized:
        onStatusOnMainQueue(.authorized)

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
