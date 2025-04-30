# Grabber - E-commerce Flutter App

Grabber is a modern e-commerce mobile application built with Flutter, featuring a clean architecture and powerful state management using the BLoC pattern. The app provides a seamless shopping experience with features like product browsing, search functionality, cart management, and theme customization.

## Features

- **Product Browsing**: Browse through a wide range of products with image sliders and category filters
- **Search Functionality**: Advanced search with real-time filtering and suggestions
- **Cart Management**: Add/remove products from cart with quantity control
- **Theme Support**: Toggle between light and dark themes
- **Authentication**: Secure user authentication using Firebase
- **Responsive Design**: Works seamlessly across different screen sizes
- **State Management**: Efficient state management using BLoC pattern
- **Data Persistence**: Local storage support using HydratedBloc
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Payment Processing**: Secure payment integration with validation
- **Dependency Injection**: Clean architecture with GetIt service locator
- **Offline Support**: Basic functionality available without internet connection

## Tech Stack

- **Framework**: Flutter
- **State Management**: flutter_bloc, hydrated_bloc
- **Backend**: Firebase
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **Dependency Injection**: get_it
- **Routing**: Go Router
- **Error Handling**: Custom error handlers with localized messages
- **Network**: dio with interceptors

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Firebase project setup

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/grabber.git
```

2. Navigate to project directory
```bash
cd grabber
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── di/                 # Dependency injection
│   ├── router/             # App routing
│   ├── theme/              # App theming
│   └── widgets/            # Shared widgets
├── features/
│   ├── auth/              # Authentication
│   ├── product/           # Product management
│   └── search/            # Search functionality
└── main.dart              # App entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
