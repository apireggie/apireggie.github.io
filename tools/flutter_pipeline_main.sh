#!/bin/zsh

cd ~/suite/tools || exit

echo "🧠 Launching Step 1: Hot Reload..."
./step1_hot_reload.sh &

echo "🚀 Launching Step 2: Auto-Commit & Deploy"
./step2_git_push_deploy.sh