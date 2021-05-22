//
//  File.swift
//  
//
//  Created by Ahmed M. Hassan on 22/05/2021.
//

import UIKit

// MARK: - AlertPermissionDialog
//
public struct AlertPermissionDialog: PermissionDialog {
  
  /// To present different alerts
  ///
  private(set) weak var presentationController: UIViewController?
  
  /// Configurations
  ///
  let configuration: Configuration
  
  /// Init
  ///
  public init(presenter presentationController: UIViewController, configuration: Configuration) {
    self.presentationController = presentationController
    self.configuration = configuration
  }
  
  /// Alert to be shown before attempt to request permission for the first time
  ///
  public func showPermissionAlert(onAllow: @escaping (() -> Void)) {
    let cancelAction = UIAlertAction(title: configuration.cancel, style: .cancel, handler: nil)
    let allowAction = UIAlertAction(title: configuration.allow, style: .default) { _ in
      onAllow()
    }
    
    showAlert(actions: [allowAction, cancelAction])
  }
  
  /// If user dened access, an alert to be shown to open app settings so the user can allow access
  ///
  public func showSettingsAlert() {
    let cancelAction = UIAlertAction(title: configuration.cancel, style: .cancel, handler: nil)
    let settingsAction = UIAlertAction(title: configuration.settings, style: .default) { _ in
      openSettingsUrl()
    }

    showAlert(actions: [settingsAction, cancelAction])
  }
}

// MARK: - Private Handlers
//
private extension AlertPermissionDialog {
  
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
