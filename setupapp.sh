#!/bin/bash

set -e

REPO_URL="https://github.com/angka/silly-lobster-climb.git"
APP_DIR="$HOME/apps/silly-lobster-climb"

echo "🚀 Starting Dyad app setup..."

# Check required tools
echo "🔍 Checking requirements..."

if ! command -v git &> /dev/null
then
  echo "❌ git not found. Installing..."
  sudo apt update && sudo apt install -y git
fi

if ! command -v node &> /dev/null
then
  echo "❌ Node.js not found. Please install Node.js first."
  exit 1
fi

if ! command -v docker &> /dev/null
then
  echo "❌ Docker not found. Please install Docker first."
  exit 1
fi

echo "✅ All requirements found"

# Create apps directory
mkdir -p "$HOME/apps"

# Clone repo
if [ -d "$APP_DIR" ]; then
  echo "⚠️ Directory already exists. Pulling latest changes..."
  cd "$APP_DIR"
  git pull
else
  echo "📥 Cloning repository..."
  git clone "$REPO_URL" "$APP_DIR"
  cd "$APP_DIR"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Setup environment file if not exists
if [ ! -f ".env" ]; then
  echo "⚙️ Creating default .env file..."
  cp .env.example .env 2>/dev/null || echo "No .env.example found, skipping"
fi

# Optional: build (if project uses build step)
if grep -q "\"build\"" package.json; then
  echo "🏗️ Building project..."
  npm run build
fi

# Run docker services if docker-compose exists
if [ -f "docker-compose.yml" ]; then
  echo "🐳 Starting Docker services..."
  docker compose up -d
fi

# Start app
echo "🚀 Starting application..."
if grep -q "\"start\"" package.json; then
  npm run start
else
  echo "ℹ️ No start script found. Try manually:"
  echo "npm run dev"
fi

echo "✅ Setup complete!"
