#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  source .env
else
  echo "❌ .env file not found!"
  exit 1
fi

# Set Git identity
git config user.name "$GIT_COMMIT_USER"
git config user.email "$GIT_COMMIT_EMAIL"

echo "🔄 Running flutter pub get..."
flutter pub get || { echo "❌ flutter pub get failed"; exit 1; }

echo "🔨 Building Flutter Web..."
flutter build web --release || { echo "❌ Flutter build failed"; exit 1; }

# Check for changes
if [ -n "$(git status --porcelain)" ]; then
  echo "📝 Committing changes..."
  git add .
  COMMIT_MSG="Update: minor changes in AppRegin Suite"
  
  # Optional: Generate commit message with OpenAI
  if [ -n "$OPENAI_API_KEY" ]; then
    DIFF=$(git diff --cached)
    COMMIT_MSG=$(curl -s https://api.openai.com/v1/chat/completions \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "model": "gpt-4o",
        "messages": [{"role": "user", "content": "Write a Git commit message for the following diff:\n'"$DIFF"'"}],
        "max_tokens": 30
      }' | jq -r '.choices[0].message.content' | tr -d '\n')
  fi

  git commit -m "$COMMIT_MSG"
  
  echo "🚀 Pushing to origin/main..."
  git push origin main
else
  echo "🧘‍♂️ No changes to commit."
fi
