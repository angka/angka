#!/bin/bash

set -e

REPO_URL="https://github.com/angka/silly-lobster-climb.git"
APP_DIR="$HOME/apps/silly-lobster-climb"

echo "🚀 Starting Dyad app setup..."

# --- CHECK REQUIREMENTS ---
echo "🔍 Checking requirements..."

if ! command -v git &> /dev/null; then
  echo "❌ git not found. Installing..."
  sudo apt update && sudo apt install -y git
fi

if ! command -v node &> /dev/null; then
  echo "❌ Node.js not found. Please install Node.js first."
  exit 1
fi

if ! command -v docker &> /dev/null; then
  echo "❌ Docker not found. Please install Docker first."
  exit 1
fi

echo "✅ All requirements found"

# --- PREPARE DIRECTORY ---
mkdir -p "$HOME/apps"

# --- CLONE OR UPDATE ---
if [ -d "$APP_DIR" ]; then
  echo "⚠️ Directory exists. Pulling latest..."
  cd "$APP_DIR"
  git pull
else
  echo "📥 Cloning repository..."
  git clone "$REPO_URL" "$APP_DIR"
  cd "$APP_DIR"
fi

# --- REMOVE PREVIOUSLY BUILD dist ---
  echo "remove preexisting dist build"
  rm -rf dist

echo "🎉 Setup complete! please continue with setupngingx.sh"
