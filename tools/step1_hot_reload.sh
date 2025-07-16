#!/bin/zsh

export PATH="$HOME/flutter/bin:$PATH"
cd ~/suite || exit

echo "🚀 Starting Flutter in Chrome..."
flutter pub get
flutter run -d chrome