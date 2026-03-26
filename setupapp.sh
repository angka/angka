#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/angka/silly-lobster-climb.git"

# Detect real user (even when using sudo)
REAL_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo "~$REAL_USER")
APP_DIR="$USER_HOME/apps/silly-lobster-climb"

echo "🚀 Starting EMR Contact Lens setup..."
echo "👤 Running as user: $REAL_USER"
echo "📁 Installing to: $APP_DIR"

# جلوگیری running as pure root
if [ "$REAL_USER" = "root" ]; then
  echo "❌ Please run this script as a normal user (with sudo if needed), not as root."
  exit 1
fi

# --- CHECK REQUIREMENTS ---
echo "🔍 Checking requirements..."

# Git
if ! command -v git &> /dev/null; then
  echo "📦 Installing git..."
  sudo apt update
  sudo apt install -y git
fi

# Node.js
if ! command -v node &> /dev/null; then
  echo "❌ Node.js not found. Please install Node.js (>=18) first."
  exit 1
else
  NODE_VERSION=$(node -v | cut -d. -f1 | tr -d 'v')
  if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version must be >= 18. Current: $(node -v)"
    exit 1
  fi
fi

# Docker
if ! command -v docker &> /dev/null; then
  echo "❌ Docker not found. Please install Docker first."
  exit 1
fi

# Docker permission check
if ! groups "$REAL_USER" | grep -q docker; then
  echo "⚠️ Adding user to docker group..."
  sudo usermod -aG docker "$REAL_USER"
  echo "⚠️ Please logout and login again for Docker permission to apply."
fi

echo "✅ All requirements OK"

# --- PREPARE DIRECTORY ---
mkdir -p "$USER_HOME/apps"

# --- CLONE OR UPDATE ---
if [ -d "$APP_DIR/.git" ]; then
  echo "🔄 Repository exists. Pulling latest changes..."
  cd "$APP_DIR"
  git pull --ff-only
else
  echo "📥 Cloning repository..."
  git clone "$REPO_URL" "$APP_DIR"
  cd "$APP_DIR"
fi

# --- CLEAN PREVIOUS BUILD ---
if [ -d "dist" ]; then
  echo "🧹 Removing existing dist build..."
  rm -rf dist
fi

echo "🎉 Setup complete!"
echo "➡️ Next step: run ./setupnginx.sh"
