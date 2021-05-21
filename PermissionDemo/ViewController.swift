//
//  ViewController.swift
//  PermissionDemo
//
//  Created by Ahmed M. Hassan on 21/05/2021.
//

import UIKit

// MARK: - ViewController
//
class ViewController: UIViewController {
  
  // MARK: Outlets

  let segmentControl = UISegmentedControl(items: ViewController.types.map { $0.description} )
  let button = UIButton(type: .system)
  let label = UILabel()
  
  // MARK: Proeprties
  
  static let types: [PermissionType] = [
    .camera,
    .notification(options: [.alert]),
    .location(locationType: .always)
  ]
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    segmentControl.selectedSegmentIndex = .zero
    segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
    
    button.setTitle("Get Permission", for: .normal)
    button.addTarget(self, action: #selector(getPermission), for: .touchUpInside)
    
    let stackView = UIStackView(arrangedSubviews: [segmentControl, button, label])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  // MARK: Handlers
  
  @objc func getPermission() {
    let index = segmentControl.selectedSegmentIndex
    let selectedType = ViewController.types[index]
    let permission = Permission(presenter: self, type: selectedType)
    
    permission.request { [weak self] status in
      self?.label.text = status.description
    }
  }
  
  @objc func segmentControlValueChanged() {
    label.text = nil
  }
}

// MARK: - String Helpers

extension PermissionStatus: CustomStringConvertible {
  var description: String {
    switch self {
    case .authorized:
      return "Authorized"
    case .denied:
      return "Denied"
    case .notDetermined:
      return "Not Determined"
    case .disabled:
      return "Disabled"
    }
  }
}

extension PermissionType: CustomStringConvertible {
  var description: String {
    switch self {
    case .camera:
      return "Camera"
    case .notification:
      return "Notifications"
    case .location:
      return "Location"
    }
  }
}
