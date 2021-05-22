//
//  File.swift
//  
//
//  Created by Ahmed M. Hassan on 22/05/2021.
//

import Foundation

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
