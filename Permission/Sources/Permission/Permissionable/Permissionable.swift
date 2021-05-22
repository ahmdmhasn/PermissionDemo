//
//  Permissionable.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import Foundation

// MARK: - Permissionable
//
protocol Permissionable {
  
  typealias PermissionHandler = (PermissionStatus) -> Void
  
  /// Request permission
  ///
  func request(onStatus: @escaping PermissionHandler)
  
  /// Check current status
  ///
  func authorizationStatus(onStatus: @escaping PermissionHandler)
  
  /// Dialog configurations; Mainly for dialogs presented
  ///
  var configuration: Configuration { get }
}
