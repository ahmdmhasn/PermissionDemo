//
//  File.swift
//  
//
//  Created by Ahmed M. Hassan on 22/05/2021.
//

import Foundation

// MARK: - Dialog configrations
//
public protocol Configuration {
  
  /// Dialog title
  ///
  var title: String { get }
  
  /// Dialog message
  ///
  var message: String { get }
  
  /// Allow text
  ///
  var allow: String { get }
  
  /// Cancel text
  ///
  var cancel: String { get }
  
  /// Settings text
  ///
  var settings: String { get }
}

// MARK: - Default Implementation
//
extension Configuration {
    
  var allow: String {
    return "Allow"
  }
  
  var cancel: String {
    return "Cancel"
  }
  
  var settings: String {
    return "Settings"
  }
}

// MARK: - ConfigurationWrapper - Wraps required `Configuration` data
//
struct ConfigurationWrapper: Configuration {
  let title: String
  let message: String
}
