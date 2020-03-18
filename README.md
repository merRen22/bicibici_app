# bicibici

This project is a prototype of how a bike sharing system would be implemented. This repository contains the app that the users would use to request a ride by scanning a QR code. It also includes managment of user account using AWS Cognito and connection to an API build using NodeJS and AWS Lambda.

## Google Maps

In order to use this app a Google Maps Key needs to be added. This key needs to be created via the google cloud platform. Once this key is created it needs toi be inserted in the following files: AndroidManifest.xml and AppDelegate.swift

### AndroidManifest.xml

```xml
    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="bicibici"
        android:icon="@mipmap/ic_launcher">
        <meta-data android:name="com.google.android.geo.API_KEY"
            android:value="AIza... Put maps key here"/>
            ...
```

### AppDelegate.swift

```swift
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        GMSServices.provideAPIKey("AIza... Put maps key here")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

## API and Monitoring

This app consumes an API build using AWS API Gateway, AWS Lambda and DynamoDB. The source code for this project can be found in backend_bicibici repository (https://github.com/merRen22/backend_bicibici)

Along with this app a web application that allows admin users to monitor the state of the system on real was build using React JS. This app can be found in the backend_bicibici_admin repository (https://github.com/merRen22/backend_bicibici_admin)

- Renato Mercado 19/04/2019

Nota elminar provideAPIKey en swift
