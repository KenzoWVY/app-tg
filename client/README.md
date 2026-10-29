[English](./README.md) | [Português](./README.pt.md)

### Prerequisites

* Flutter SDK installed locally
* For the intended experience, a connected mobile device or emulator

### 1. Install Dependencies
Navigate to the frontend directory and fetch project dependencies:

```bash
flutter pub get
```

### 2. Run Code Generation
Build and run the program, choosing your preferred device:
```bash
flutter run
```

If using an external server as API, use:
```bash
flutter run --dart-define=API_URL=YOUR_API_URL_HERE
```
Or change the default value on lib/core/dio_provider.dart