@echo off
echo Building Flutter Web App for GitHub Pages...

REM Clean and get dependencies
flutter clean
flutter pub get

REM Run build_runner for JSON serialization
flutter packages pub run build_runner build --delete-conflicting-outputs

REM Build for web with correct base href
flutter build web --release --base-href "/wearables/"

echo.
echo Build completed successfully!
echo.
echo To deploy manually:
echo 1. Copy contents of build/web/ to your GitHub Pages
echo 2. Or use: gh-pages -d build/web
echo 3. Or drag build/web/ to Netlify Drop
echo.
echo Your app is ready at: build/web/
pause
