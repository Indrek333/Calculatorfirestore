# myapp

A new Flutter project.

## Firebase setup

This app uses Firebase Auth and Cloud Firestore. Before running the app, generate
the Firebase configuration files with the FlutterFire CLI:

```bash
flutterfire configure
```

Then replace `lib/firebase_options.dart` with the generated file and ensure the
platform files (such as `android/app/google-services.json` and
`ios/Runner/GoogleService-Info.plist`) are created for your project. Android
requires the Google Services Gradle plugin plus a valid `google-services.json`
file to generate the `values.xml` resources consumed by Firebase Core. If you
prefer the native configuration route, `Firebase.initializeApp()` will fall back
to platform config when `firebase_options.dart` is not populated.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.