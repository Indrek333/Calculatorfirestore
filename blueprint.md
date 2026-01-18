# Project Blueprint

## Overview

This document outlines the architecture, features, and design of the Flutter application. It serves as a single source of truth for the project's current state and future development plans.

## Implemented Features

### Firebase Integration

*   **Firebase Project:** `indrek-project`
*   **Initialized Services:**
    *   **Firestore:** For database storage.
    *   **Hosting:** For deploying the web version of the app.
*   **Platform Configuration:**
    *   **Android:** Configured with `google-services.json`.
    *   **Web:** Configured with `firebase_options.dart`.

### Authentication

*   **Login Screen:** A screen for users to sign in or create an account using email and password.
*   **Authentication Service:** A service to handle Firebase Authentication.
*   **Authentication Wrapper:** A widget that directs users to the appropriate screen based on their authentication state.
*   **Logout Button:** A button on the calculator screen to log out the current user.

### History

*   **Firestore History:** Calculation history is saved to Firestore for each user.
*   **History View:** A view that displays the user's calculation history from Firestore.
*   **Clear History Button:** A button on the history view to clear the user's calculation history.

## Current Plan

### Authentication and History

*   [x] Create a login screen with email and password authentication.
*   [x] Implement an authentication service to interact with Firebase.
*   [x] Create an authentication wrapper to manage user sessions.
*   [x] Add a feature to save calculation history to Firestore.
*   [x] Add a logout button to the calculator screen.
*   [x] Add a clear history button to the history view.
