# Movie App Case - Flutter Authentication System

A comprehensive Flutter application with clean architecture and JWT authentication system.

## 🏗️ Architecture

This project implements Clean Architecture with clear separation of concerns:

```
lib/
├── core/                           # Core utilities and shared components
│   ├── constants/                  # API endpoints and app constants
│   ├── error/                      # Error handling (failures & exceptions)
│   ├── network/                    # HTTP client with error handling
│   ├── utils/                      # Logging and secure storage utilities
│   └── injection_container.dart    # Dependency injection setup
├── features/auth/                  # Authentication feature
│   ├── data/                       # Data layer
│   │   ├── datasources/            # Remote data sources
│   │   ├── models/                 # Data transfer objects
│   │   └── repositories/           # Repository implementations
│   ├── domain/                     # Business logic layer
│   │   ├── entities/               # Core business entities
│   │   ├── repositories/           # Repository interfaces
│   │   └── usecases/               # Business use cases
│   └── presentation/               # UI layer
│       ├── bloc/                   # BLoC state management
│       ├── pages/                  # Screen widgets
│       └── widgets/                # Reusable UI components
└── main.dart                       # Application entry point
```

## 🔐 Authentication Features

### Core Functionality
- ✅ User Registration with email, name, and password
- ✅ User Login with email and password
- ✅ JWT token-based authentication
- ✅ Secure token storage using Flutter Secure Storage
- ✅ Auto-login on app restart if valid token exists
- ✅ User profile display with token validation
- ✅ Secure logout with token cleanup

### API Integration
- **Base URL**: `https://caseapi.servicelabs.tech`
- **Register**: `POST /user/register`
- **Login**: `POST /user/login`
- **Profile**: `GET /user/profile` (with Bearer token)

### UI/UX Features
- ✅ Modern Material Design interface
- ✅ Form validation with real-time feedback
- ✅ Loading states and error handling
- ✅ Responsive design for different screen sizes
- ✅ Smooth animations and transitions
- ✅ Password visibility toggle
- ✅ Error messages with retry options

## 📱 Screens

### Splash Screen
- Shows app logo with animation
- Checks for existing authentication token
- Auto-navigates to appropriate screen (Login or Profile)

### Login Screen
- Email and password input with validation
- Remember credentials functionality
- Navigation to registration
- Error handling with user-friendly messages

### Registration Screen
- Full name, email, password, and confirm password fields
- Input validation (email format, password strength, password matching)
- Automatic login after successful registration

### Profile Screen
- Display user information (ID, name, email)
- Refresh profile data functionality
- Logout with confirmation dialog
- Modern card-based layout

## 🛠️ Technical Implementation

### Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.3          # State management
  http: ^1.1.0                  # Network requests
  flutter_secure_storage: ^9.0.0 # Secure token storage
  get_it: ^7.6.4                # Dependency injection
  dartz: ^0.10.1                # Functional programming
  logger: ^2.0.2+1              # Logging system
```

### State Management
- **BLoC Pattern**: Complete implementation with events and states
- **Events**: CheckAuthStatus, Login, Register, GetProfile, Logout
- **States**: Initial, Loading, Authenticated, Unauthenticated, Error

### Error Handling
- Network connectivity errors
- Server response errors (4xx, 5xx)
- Authentication failures
- Validation errors
- Secure storage errors

### Security Features
- JWT tokens stored in encrypted secure storage
- HTTPS requests with proper headers
- Token validation on app startup
- Automatic token cleanup on logout
- Input sanitization and validation

## 🚀 Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the Application**
   ```bash
   flutter run
   ```

3. **Test Credentials**
   - Existing user: `safa@nodelabs.com` / `123451`
   - Or register a new account with any valid email

## 🧪 Testing

The app includes comprehensive error handling and can be tested with:
- Valid login credentials
- Invalid credentials to test error handling
- New user registration
- Network connection issues
- Token expiration scenarios

## 📊 Code Quality

- **Clean Architecture**: Clear separation of data, domain, and presentation layers
- **SOLID Principles**: Well-structured, maintainable code
- **Error Handling**: Comprehensive error management
- **Code Coverage**: All critical paths covered with proper error states
- **Performance**: Optimized with proper state management and caching

## 🔧 Environment Setup

The application is designed to work with the provided API endpoints and includes:
- Proper timeout handling (30 seconds)
- Network error recovery
- User-friendly error messages
- Offline state handling
- Token refresh capabilities (if needed)

This implementation provides a solid foundation for a production-ready Flutter authentication system with modern architecture patterns and best practices.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# movie-app-case
