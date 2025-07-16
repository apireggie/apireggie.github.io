AppRegin Suite 📱💻

Welcome to the AppRegin Suite — a multi-platform AI-powered productivity and creativity app suite designed for web and mobile. This repo powers tools like ReggieVision, AhShayOS, and more within the AppRegin ecosystem.

⸻

🚀 Getting Started

1. ✅ Requirements
	•	Flutter (Stable Channel)
	•	Dart SDK
	•	Firebase CLI
	•	Chrome (for web)
	•	Xcode / Android Studio (for iOS & Android)

2. 📦 Install Dependencies

flutter pub get

3. 🧹 Clean Cache (if needed)

flutter clean
rm pubspec.lock
flutter pub get

4. 🌐 Run on Web (Chrome)

flutter run -d chrome

Note: Make sure your firebase_auth_web, firebase_core_web, and js packages are up-to-date and compatible with the stable Flutter channel.

⸻

🗂 Project Structure

lib/
├── core/              # Shared utils (themes, constants, services)
├── data/              # API clients, repositories, models
├── features/          # Modular by domain (auth, chat, etc.)
│   └── auth/
│       ├── bloc/
│       ├── pages/
│       ├── widgets/
├── shared/            # Reusable widgets & extensions
├── app.dart           # App-level config (routes, themes)
└── main.dart          # Entry point

🧠 Tooling

tool/
├── run_hot_reload.command
├── fix_ndk.sh
├── fixandroid.sh

🔥 Features
	•	🔐 Auth (Firebase)
	•	💬 Chat
	•	🎨 Custom Theming
	•	🌍 Web + Mobile Ready
	•	🧠 AI Hooks (Coming soon)

⸻

🤔 Troubleshooting

Firebase Web Errors?

Make sure:
	•	You’re on the stable channel
	•	js package is added
	•	No stale .pub-cache leftovers (delete ~/.pub-cache if needed)

⸻

👑 Author

Reggie Da Poêt
Lead Developer • Visual Storyteller • ATLien 📍

Follow the vision:
📸 @reggiedapoet
🌐 appregin.com

⸻

📄 License

Copyright © 2025 AppRegin Inc. All Rights Reserved.

You may not modify, distribute, sublicense, or sell this software without express written permission from AppRegin Inc.

For commercial licensing inquiries, please contact: txtme@appregin.com

“Build it so others may see themselves in the blueprint.” – Reggie