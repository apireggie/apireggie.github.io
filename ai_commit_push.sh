#!/bin/bash

set -e

# Load environment variables
if [ -f .env ]; then
  set -a
  source .env
  set +a
else
  echo "⚠️ .env file not found."
  exit 1
fi

# Build Flutter Web
echo "🔨 Building Flutter Web..."
flutter build web --release --base-href="/"

# Get AI commit message or fallback
echo "💬 Consulting AhShay OS for commit message..."
DIFF=$(git diff HEAD)

MESSAGE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "Write a short git commit message summarizing:\n'"$DIFF"'"}],
    "max_tokens": 60
  }' | jq -r '.choices[0].message.content')

if [ -z "$MESSAGE" ] || [ "$MESSAGE" = "null" ]; then
  MESSAGE="🚀 Auto-commit: minor update"
fi

echo "📝 Committing with message: $MESSAGE"

# Git commands
git add .
git commit -m "$MESSAGE"
git push origin main

echo "✅ Deploy complete."
