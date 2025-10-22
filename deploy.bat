@echo off
REM Flutter Biometrics Dashboard - GitHub Pages Deployment Script (Windows)

echo 🚀 Deploying Flutter Biometrics Dashboard to GitHub Pages...

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    pause
    exit /b 1
)

REM Check if git is initialized
if not exist ".git" (
    echo 📁 Initializing git repository...
    git init
    git add .
    git commit -m "Initial commit: Flutter Biometrics Dashboard"
)

REM Get dependencies
echo 📦 Getting Flutter dependencies...
flutter pub get

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean

REM Build for web
echo 🔨 Building Flutter web app...
flutter build web --release --base-href "/wearables/"

REM Check if build was successful
if not exist "build\web" (
    echo ❌ Build failed. Please check for errors.
    pause
    exit /b 1
)

echo ✅ Build successful!

REM Add all files to git
echo 📝 Adding files to git...
git add .

REM Commit changes
echo 💾 Committing changes...
git commit -m "Deploy Flutter Biometrics Dashboard %date% %time%"

REM Push to main branch (this will trigger GitHub Actions)
echo 🚀 Pushing to GitHub...
git push origin main

echo.
echo 🎉 Deployment initiated!
echo.
echo 📋 Next steps:
echo 1. Go to your GitHub repository
echo 2. Click on 'Actions' tab
echo 3. Wait for 'Deploy Flutter Web to GitHub Pages' workflow to complete
echo 4. Go to Settings → Pages to enable GitHub Pages
echo 5. Your app will be available at: https://[your-username].github.io/wearables/
echo.
echo 🔧 If you encounter issues:
echo - Check the Actions tab for build errors
echo - Ensure GitHub Pages is enabled in repository settings
echo - Verify the base-href matches your repository name
echo.
echo ✨ Your Flutter Biometrics Dashboard will be live soon!
pause
