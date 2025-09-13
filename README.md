# 🌱 AgroCure - Agricultural Disease Prediction App

A comprehensive Flutter application designed to help farmers predict and manage plant diseases through AI-powered analysis, real-time weather monitoring, and detailed precautionary guidance.

## 📱 Features

### 🔐 User Authentication
- **Secure Login System**: Phone number and OTP-based authentication
- **User Registration**: Easy signup process with validation
- **Profile Management**: Update user information and account settings
- **Session Management**: Persistent login with SharedPreferences

### 🧠 AI Disease Prediction
- **Machine Learning Integration**: Connects to backend API for disease prediction
- **Visual Analytics**: Interactive bar charts and pie charts showing disease probabilities
- **Real-time Predictions**: Get instant disease analysis results
- **Comprehensive Disease Database**: Support for 20+ common plant diseases

### 🌤️ Weather Monitoring
- **Real-time Weather Data**: Current weather conditions using WeatherStack API
- **Location-based Services**: GPS-enabled weather tracking
- **Weather Icons**: Visual representation of weather conditions
- **Detailed Metrics**: Temperature, humidity, precipitation, sunrise/sunset times

### 📊 Data Visualization
- **Interactive Charts**: Bar charts and pie charts for disease probability analysis
- **Statistical Insights**: Visual representation of prediction results
- **Responsive Design**: Optimized for mobile viewing

### 🛡️ Disease Management
- **Precautionary Measures**: Detailed prevention strategies for each disease
- **Educational Videos**: YouTube integration for disease treatment tutorials
- **Disease Database**: Comprehensive information on 20+ plant diseases including:
  - Alternaria Complex
  - Anthracnose
  - Bacterial Wilt
  - Fusarium Wilt
  - Root Rot diseases
  - And many more...

## 🏗️ Technical Architecture

### Frontend (Flutter)
- **Framework**: Flutter 3.6.1+
- **State Management**: Global state with static classes
- **Navigation**: Named routes with custom navigation bar
- **UI Components**: Custom widgets and Material Design

### Backend Integration
- **API Service**: RESTful API communication
- **Authentication**: JWT-based user authentication
- **Data Storage**: SQLite local database + SharedPreferences
- **External APIs**: WeatherStack for weather data

### Key Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  http: ^0.13.6                    # API communication
  shared_preferences: ^2.2.2       # Local data storage
  sqflite: ^2.3.0                  # SQLite database
  geolocator: ^10.1.0              # GPS location services
  permission_handler: ^11.0.1      # Runtime permissions
  fl_chart: ^0.63.0                # Data visualization
  url_launcher: ^6.1.10            # External URL handling
  intl: ^0.19.0                    # Internationalization
```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point and routing
├── database/
│   └── database_helper.dart       # SQLite database operations
└── pages/
    ├── api_service.dart           # Backend API integration
    ├── home_page.dart             # Main dashboard
    ├── login_page.dart            # User authentication
    ├── registration_page.dart     # User registration
    ├── weather_page.dart          # Weather monitoring
    ├── chart_page.dart            # Data visualization
    ├── account_page.dart          # User profile management
    ├── disease_precautions.dart   # Disease database
    ├── prediction_state.dart      # Global state management
    └── common_widgets/
        ├── custom_nav_bar.dart    # Navigation component
        ├── loading_page.dart      # Loading screen
        └── logout_button.dart     # Logout functionality
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.6.1 or higher
- Dart SDK
- Android Studio / VS Code
- Android device or emulator
- Backend API server running on `http://192.168.1.20:8000`

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/agrocure.git
   cd agrocure
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   - Update `lib/pages/api_service.dart` with your backend URL
   - Update login/registration endpoints in respective files

4. **Set up weather API**
   - Get API key from [WeatherStack](https://weatherstack.com/)
   - Update `apiKey` in `lib/pages/weather_page.dart`

5. **Run the application**
   ```bash
   flutter run
   ```

### Backend Setup
Ensure your backend API is running with the following endpoints:
- `POST /auth/login` - User authentication
- `POST /auth/register` - User registration
- `GET /auth/user/{phone}` - Get user details
- `POST /auth/update_user` - Update user profile
- `GET /predict` - Disease prediction

## 📱 Screenshots

### Main Dashboard
- Disease prediction cards
- Precautionary measures
- Educational video links

### Weather Page
- Real-time weather data
- Location-based information
- Weather icons and metrics

### Analytics Page
- Interactive bar charts
- Pie chart visualization
- Disease probability analysis

### Profile Management
- User information editing
- Account settings
- Logout functionality

## 🔧 Configuration

### API Configuration
Update the following files with your backend URLs:
- `lib/pages/api_service.dart` - Main API base URL
- `lib/pages/login_page.dart` - Login endpoint
- `lib/pages/registration_page.dart` - Registration endpoint
- `lib/pages/account_page.dart` - User management endpoints

### Weather API Setup
1. Sign up at [WeatherStack](https://weatherstack.com/)
2. Get your API key
3. Update `apiKey` in `lib/pages/weather_page.dart`

### Permissions
The app requires the following permissions:
- **Location**: For weather data based on GPS coordinates
- **Internet**: For API calls and weather data

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## 👥 Authors

- **Shrikar Kolte** - *Data Preparation and Model Building* - [YourGitHub](https://github.com/shrikarK10)
- **Robin Wadekar** - *Android App Design and Model Integration* - [YourGitHub](https://github.com/RobinWadekar)
- **Yash Shivatare** - *API Mangement and Integration* - [YourGitHub](https://github.com/yashivatare)

## 🙏 Acknowledgments

- Weather data provided by [WeatherStack](https://weatherstack.com/)
- Disease information sourced from agricultural research databases
- Educational videos from YouTube agricultural channels
- Flutter community for excellent packages and documentation

## 📞 Support

For support, email support@agrocure.com or create an issue in this repository.

## 🔮 Future Enhancements

- [ ] Offline mode for disease database
- [ ] Push notifications for weather alerts
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Integration with IoT sensors
- [ ] Community features for farmers
- [ ] Expert consultation booking
- [ ] Crop calendar integration

---

**Made with ❤️ for the farming community**