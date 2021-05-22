//
//  PermissionDialog.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import UIKit

// MARK: - PermissionDialog
//
public struct PermissionDialog {
  
  /// To present different alerts
  ///
  private weak var presentationController: UIViewController?
  
  /// Configurations
  ///
  let configuration: Configuration
  
  /// Init
  ///
  init(presenter presentationController: UIViewController?, configuration: Configuration) {
    self.presentationController = presentationController
    self.configuration = configuration
  }
  
  /// Alert to be shown before attempt to request permission for the first time
  ///
  func showPermissionAlert(permissionHandler: @escaping (() -> Void)) {
    let allowAction = UIAlertAction(title: configuration.allow, style: .default) { _ in
      permissionHandler()
    }
    
    showAlert(actions: [allowAction])
  }
  
  /// If user dened access, an alert to be shown to open app settings so the user can allow access
  ///
  func showSettingsAlert() {
    let cancelAction = UIAlertAction(title: configuration.cancel, style: .cancel, handler: nil)
    let settingsAction = UIAlertAction(title: configuration.settings, style: .default) { _ in
      openSettingsUrl()
    }

    showAlert(actions: [settingsAction, cancelAction])
  }
    
  /// Show alert handler with actions
  ///
  private func showAlert(actions: [UIAlertAction]) {
    let alertController = UIAlertController(
      title: configuration.title,
      message: configuration.message,
      preferredStyle: .alert
    )
        
    actions.forEach { action in
      alertController.addAction(action)
    }
    
    DispatchQueue.main.async {
      presentationController?.present(alertController, animated: true)
    }
  }
  
  /// Open app settings url if possible
  ///
  private func openSettingsUrl() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl) { _ in }
    }
  }
}

// MARK: - Configuration
//
public extension PermissionDialog {
  
  /// Dialog configrations
  ///
  struct Configuration {
    let title: String
    let message: String
    let allow: String
    let cancel: String
    let settings: String
    
    public init(title: String = "Allow access to your location",
         message: String = "We uses your location to show local content, improve recommendations, and more.",
         allow: String = "Allow",
         cancel: String = "Cancel",
         settings: String = "Settings") {
      self.title = title
      self.message = message
      self.allow = allow
      self.cancel = cancel
      self.settings = settings
    }
  }
}
