//
//  Permission.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import UIKit

// MARK: - Permission
//
public struct Permission {
    
  /// Permissionable
  ///
  let permissionable: Permissionable
  
  /// PermissionDialog - Responsible for settinga and permission alerts
  ///
  let dialog: PermissionDialog
  
  ///   /// Permission Init
  ///
  /// - Parameters:
  ///   - presenter: Used to present dialog
  ///   - type: Permission type
  ///   - configuration: Dialog configurations; Pass nil to used default value.
  public init(presenter: UIViewController,
              type: PermissionType,
              configuration: Configuration? = nil) {
    let permissionable = Permission.permission(of: type)
    let config = configuration ?? permissionable.configuration
    let dialog = PermissionDialog(presenter: presenter, configuration: config)
    
    self.init(permissionable: permissionable, dialog: dialog)
  }
  
  /// Init
  ///
  init(permissionable: Permissionable, dialog: PermissionDialog) {
    self.permissionable = permissionable
    self.dialog = dialog
  }
  
  /// Request permission.
  /// Completion the `PermissionStatus` type on the main thread.
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

// MARK: - Static Helpers
//
extension Permission {
  
  /// Returns `Permissionable` for `PermissionType`
  ///
  static func permission(of type: PermissionType) -> Permissionable {
    switch type {
    case .notification(let options):
      return NotificationPermission(options: options)
      
    case .camera:
      return CameraPermission()
      
    case .location(let locationType):
      return LocationPermission(type: locationType)
    }
  }
}
