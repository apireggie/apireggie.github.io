#!/bin/zsh

export PATH="$HOME/flutter/bin:$PATH"
cd ~/suite || exit

DATE=$(date "+%Y-%m-%d %H:%M")
SUMMARY="chore: auto-commit from $(whoami) at $DATE"

echo "📝 $SUMMARY"
git add .
git commit -m "$SUMMARY"
git push origin main

echo "📦 Building for web..."
flutter build web

echo "🌐 Deploying to GitHub Pages..."
cd build/web || exit
git init
git remote add origin https://github.com/reginaldappiah/reginaldappiah.github.io.git
git add .
git commit -m "Deploy $DATE"
git push --force origin main