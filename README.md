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
Web nõuab alati `firebase_options.dart` faili, sest brauseris ei ole
platvormipõhist konfiguratsiooni, millest vaikekonfiguratsiooni võtta.

## Firebase emulator setup

The app can connect to Firebase Auth and Firestore emulators when built with
`--dart-define=USE_FIREBASE_EMULATOR=true`. The emulator host defaults to
`localhost` for web and `10.0.2.2` for Android emulators. Start your Firebase
emulators (Auth on `9099`, Firestore on `8080`) before running the app:

```bash
firebase emulators:start --only auth,firestore
```

Then launch the app with:

```bash
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.