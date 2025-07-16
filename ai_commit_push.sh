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

# Check for changes before building
if git diff --quiet && git diff --cached --quiet; then
  echo "🧘‍♂️ No changes detected. Skipping build and push."
  exit 0
fi

# Build Flutter Web faster
echo "🔨 Building Flutter Web (release, no tree shake icons)..."
flutter build web --release --base-href="/" --no-tree-shake-icons

# Write CNAME if defined
if [ -n "$CNAME_DOMAIN" ]; then
  echo "$CNAME_DOMAIN" > build/web/CNAME
  echo "🌐 CNAME set to: $CNAME_DOMAIN"
fi

# Generate commit message if needed
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

# Git deploy
git add .
git commit -m "$MESSAGE" || echo "✅ Nothing to commit."
git push origin main

echo "✅ Deploy complete."
