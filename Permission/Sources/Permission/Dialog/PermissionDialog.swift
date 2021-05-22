//
//  PermissionDialog.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import UIKit

// MARK: - PermissionDialog
//
public protocol PermissionDialog {
  
  /// Init using presenter view controller and configurations
  ///
  init(presenter presentationController: UIViewController, configuration: Configuration)

  /// Alert to be shown before attempt to request permission for the first time
  ///
  func showPermissionAlert(onAllow: @escaping (() -> Void))
  
  /// If user dened access, an alert to be shown to open app settings so the user can allow access
  ///
  func showSettingsAlert()
}
