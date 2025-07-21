# FinHabit - Personal Finance Tracker

A comprehensive Flutter application for tracking financial habits, managing transactions, setting financial goals, and monitoring personal finance.

## Features

### 🏠 Home Screen
- **Financial Dashboard**: Overview of total balance, monthly spending, goals progress, and savings
- **Recent Transactions**: Quick view of latest financial activities
- **Summary Cards**: Visual representation of key financial metrics

### 💳 Transactions Screen
- **Transaction Management**: View and manage all financial transactions
- **Filtering**: Filter transactions by type (Income, Expense, Investment)
- **Search Functionality**: Find specific transactions quickly
- **Add New Transactions**: Easy-to-use transaction entry system

### 🎯 Goals Screen
- **Financial Goals Tracking**: Set and monitor progress towards financial objectives
- **Visual Progress Indicators**: Progress bars and completion percentages
- **Goal Categories**: Emergency funds, vacation savings, car purchases, home improvements
- **Interactive Updates**: Add amounts towards goals with real-time progress updates

### 👤 Profile Screen
- **User Settings**: Manage personal information and app preferences
- **Security Settings**: Password management and biometric login options
- **App Customization**: Dark mode, notifications, currency selection
- **Support & Legal**: Access to help, terms of service, and privacy policy

## Tech Stack

- **Framework**: Flutter 3.32.5
- **Language**: Dart 3.8.1
- **State Management**: Provider pattern
- **Charts**: FL Chart for data visualization
- **HTTP Client**: For API integration
- **Local Storage**: SharedPreferences for user settings
- **Icons**: Font Awesome Flutter for extended icon set

## Project Structure

```
lib/
├── main.dart                 # App entry point and navigation
├── screens/
│   ├── home_screen.dart      # Dashboard and overview
│   ├── transactions_screen.dart # Transaction management
│   ├── goals_screen.dart     # Financial goals tracking
│   └── profile_screen.dart   # User settings and profile
```

## Getting Started

### Prerequisites

- Flutter SDK 3.32.5 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code with Flutter extensions
- Android/iOS device or emulator

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd finhabit/frontend/finhabit_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Building for Release

#### Android APK
```bash
flutter build apk --release
```

#### iOS App
```bash
flutter build ios --release
```

## App Architecture

### Navigation
- **Bottom Navigation Bar**: Primary navigation between 4 main screens
- **IndexedStack**: Maintains state across screen switches
- **Material 3 Design**: Modern UI following Google's latest design principles

### Theme
- **Primary Color**: Green (#2E7D32) - representing financial growth
- **Material 3**: Latest Material Design system
- **Dark Mode Support**: Automatic theme switching
- **Responsive Design**: Adapts to different screen sizes

### State Management
- **StatefulWidget**: For local component state
- **Provider**: For global state management (planned)
- **Local Storage**: SharedPreferences for user settings

## Key Features Implementation

### Financial Dashboard
- Real-time balance calculations
- Visual progress indicators
- Transaction categorization
- Goal progress tracking

### Data Management
- Local data storage
- Transaction filtering and sorting
- Goal progress calculations
- Settings persistence

### User Experience
- Intuitive navigation
- Responsive design
- Interactive elements
- Visual feedback

## Future Enhancements

- [ ] Backend API integration
- [ ] Real bank account connectivity
- [ ] Advanced analytics and reports
- [ ] Budget planning tools
- [ ] Investment tracking
- [ ] Bill reminders
- [ ] Export functionality
- [ ] Multi-currency support
- [ ] Offline sync capability
- [ ] Push notifications

## Configuration

### Android Configuration
The app supports Android 21+ (Android 5.0 Lollipop) and above.

### iOS Configuration
The app supports iOS 12.0 and above.

### Dependencies

Key dependencies used in this project:

- `fl_chart: ^0.69.1` - Charts and data visualization
- `http: ^1.2.2` - HTTP requests for API calls
- `shared_preferences: ^2.3.3` - Local storage
- `intl: ^0.19.0` - Date and number formatting
- `provider: ^6.1.2` - State management
- `font_awesome_flutter: ^10.8.0` - Extended icon set

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please contact the development team.

---

**FinHabit** - Building better financial habits, one transaction at a time! 💰📱
