#!/bin/bash

set -e

echo "🚀 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing curl..."
sudo apt install -y curl

echo "🐳 Installing Docker..."
sudo apt install -y ca-certificates gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🔧 Enabling Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "👤 Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "⚠️ You may need to logout/login for docker group to apply"

echo "🟢 Installing latest Node.js (via NodeSource)..."
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install -y nodejs

echo "📌 Node version:"
node -v
npm -v

echo "⚡ Installing Supabase CLI..."
npm install -g supabase

echo "📌 Supabase version:"
supabase --version

echo "📁 Initializing Supabase project..."
mkdir -p supabase_project
cd supabase_project

supabase init

echo "🐳 Starting Supabase..."
supabase start

echo "✅ DONE! Supabase is running locally."
echo "👉 Access Studio: http://localhost:54323"
