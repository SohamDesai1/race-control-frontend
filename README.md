
# Race Control 

Race Control is a Flutter application designed to provide a modern, interactive interface for motorsport race data, including live timing, driver and constructor standings, session details, and more. This project is intended to be used as the frontend for a race control system, supporting both web and mobile platforms.

## Features
- User authentication (login, registration)
- Live race data and telemetry
- Driver and constructor leaderboards
- Race and session details
- Calendar of upcoming races
- Settings and user profile management
- Responsive UI for web and mobile

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- Android Studio or VS Code (recommended for development)
- (Optional) Firebase account for authentication and backend services

### Installation
1. Clone the repository:
	 ```bash
	 git clone https://github.com/yourusername/race-control-frontend.git
	 cd race-control-frontend
	 ```
2. Install dependencies:
	 ```bash
	 flutter pub get
	 ```
3. (Optional) Configure Firebase:
	 - Update `firebase.json` and related configuration files as needed.

### Running the App
- For mobile (Android/iOS):
	```bash
	flutter run
	```
- For web:
	```bash
	flutter run -d chrome
	```

## Project Structure
- `lib/` - Main application code
	- `core/` - Constants, routing, services, theme
	- `datasources/` - Data fetching logic
	- `models/` - Data models
	- `presentation/` - UI screens and widgets
	- `repositories/` - Repository interfaces
	- `repository_impl/` - Repository implementations
	- `usecases/` - Business logic
	- `utils/` - Utility functions
	- `widgets/` - Reusable widgets
- `assets/` - Images, fonts, and other static assets
- `web/` - Web-specific files
- `android/` - Android-specific files

## Contributing
Contributions are welcome! Please open issues and submit pull requests for new features, bug fixes, or improvements.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements
- Flutter and Dart teams
- Open source motorsport APIs
- Community contributors
