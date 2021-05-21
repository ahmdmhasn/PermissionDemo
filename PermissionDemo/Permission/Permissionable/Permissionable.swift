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
  
  /// Request permission
  ///
  func request(onStatus: @escaping ((PermissionStatus) -> Void))
  
  /// Check current status
  ///
  func authorizationStatus(onStatus: @escaping ((PermissionStatus) -> Void))
}
