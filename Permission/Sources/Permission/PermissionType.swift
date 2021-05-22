//
//  File.swift
//  
//
//  Created by Ahmed M. Hassan on 22/05/2021.
//

import UIKit.UIUserNotificationSettings

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
