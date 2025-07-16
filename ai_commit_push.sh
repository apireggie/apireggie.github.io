#!/bin/bash

set -e

# Config
DRY_RUN=false
BRANCH="main"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 API REGGIE DEPLOY SCRIPT STARTING...${NC}"

# Check .env
if [ -f .env ]; then
  set -a
  source .env
  set +a
  echo -e "${GREEN}✅ .env loaded.${NC}"
else
  echo -e "${RED}⚠️ .env file not found.${NC}"
  exit 1
fi

# Check for changes
if git diff --quiet && git diff --cached --quiet; then
  echo -e "${YELLOW}🧘‍♂️ No changes detected. Skipping build and push.${NC}"
  exit 0
fi

# Build
echo -e "${YELLOW}🔨 Building Flutter Web with CSP...${NC}"
FLUTTER_WEB_RENDERER=canvaskit flutter build web --release --csp
 
# Set CNAME
if [ -n "$CNAME_DOMAIN" ]; then
  echo "$CNAME_DOMAIN" > build/web/CNAME
  echo -e "${GREEN}🌐 CNAME set to: $CNAME_DOMAIN${NC}"
fi

# Generate Commit Message
echo -e "${YELLOW}💬 Consulting AhShay OS for commit message...${NC}"
DIFF=$(git diff HEAD)
MESSAGE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "Write a short git commit message summarizing:\n'"$DIFF"'"}],
    "max_tokens": 60
  }' | jq -r '.choices[0].message.content')

[ -z "$MESSAGE" ] || [ "$MESSAGE" = "null" ] && MESSAGE="🚀 Auto-commit: minor update"

echo -e "${GREEN}📝 Commit Message: $MESSAGE${NC}"

# Commit and Push
if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}🔄 DRY RUN: Would commit and push to $BRANCH${NC}"
else
  git add .
  git commit -m "$MESSAGE" || echo -e "${YELLOW}✅ Nothing to commit.${NC}"
  git push origin $BRANCH
  echo -e "${GREEN}✅ Deploy complete.${NC}"
fi
