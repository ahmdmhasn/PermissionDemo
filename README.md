# Permission

Help in request access to device services like noitifcations, location and camera. 

# Requirements
- iOS 10.0+
- Xcode 11+
- Swift 5.1+

# Installation
## Manually
Copy the `Permission` folder to your project.

# How To Use
Add `import Permission` to your source code, unless you copied the source code.

### Request Permission
```
    let configration = Permission.Configuration()
    let permission = Permission(presenter: self, type: .camera, configuration: configration)
    
    permission.request { [weak self] status in
      print(status) // Check the received status
    }
```

### PermissionStatus
```
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
```

### PermissionType
```
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
```

### LocationPermissionType
```
public enum LocationPermissionType {
  
  /// Location services regardless of whether the app is in use.
  ///
  case always
  
  /// Location services while the app is in use.
  ///
  case whenInUse
}
```

# Note
This repo was created for demo purposes. If you find an issue, open a [ticket](https://github.com/ahmdmhasn/PermissionDemo/issues/new). Pull requests are warmly welcome as well.