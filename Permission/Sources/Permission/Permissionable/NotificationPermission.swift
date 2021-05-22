//
//  NotificationPermission.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import UIKit

// MARK: - NotificationPermission - Used to get/ request notifications permission
//
struct NotificationPermission: Permissionable {
  let options: UNAuthorizationOptions
  let current = UNUserNotificationCenter.current()

  init(options: UNAuthorizationOptions) {
    self.options = options
  }
  
  var configuration: Configuration {
    return ConfigurationWrapper(
      title: "Allow access to your notifications",
      message: "We use your notifiactions to let you up to date, send important events, and more."
    )
  }

  func request(onStatus: @escaping PermissionHandler) {
    current.requestAuthorization(options: options) { granted, error in
      onStatus(granted ? .authorized : .denied)
    }
  }
  
  func authorizationStatus(onStatus: @escaping PermissionHandler) {
    current.getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .authorized, .ephemeral, .provisional:
        onStatus(.authorized)
      case .denied:
        onStatus(.denied)
      case .notDetermined:
        onStatus(.notDetermined)
      @unknown default:
        onStatus(.notDetermined)
      }
    }
  }
}
