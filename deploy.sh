#!/bin/bash

# Flutter Biometrics Dashboard - GitHub Pages Deployment Script

echo "🚀 Deploying Flutter Biometrics Dashboard to GitHub Pages..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📁 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: Flutter Biometrics Dashboard"
fi

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Build for web
echo "🔨 Building Flutter web app..."
flutter build web --release --base-href "/wearables/"

# Check if build was successful
if [ ! -d "build/web" ]; then
    echo "❌ Build failed. Please check for errors."
    exit 1
fi

echo "✅ Build successful!"

# Add all files to git
echo "📝 Adding files to git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "Deploy Flutter Biometrics Dashboard $(date)"

# Push to main branch (this will trigger GitHub Actions)
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "🎉 Deployment initiated!"
echo ""
echo "📋 Next steps:"
echo "1. Go to your GitHub repository"
echo "2. Click on 'Actions' tab"
echo "3. Wait for 'Deploy Flutter Web to GitHub Pages' workflow to complete"
echo "4. Go to Settings → Pages to enable GitHub Pages"
echo "5. Your app will be available at: https://[your-username].github.io/wearables/"
echo ""
echo "🔧 If you encounter issues:"
echo "- Check the Actions tab for build errors"
echo "- Ensure GitHub Pages is enabled in repository settings"
echo "- Verify the base-href matches your repository name"
echo ""
echo "✨ Your Flutter Biometrics Dashboard will be live soon!"
