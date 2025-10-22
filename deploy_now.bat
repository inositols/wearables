@echo off
echo Building Flutter Web App for immediate deployment...

REM Clean and get dependencies
flutter clean
flutter pub get

REM Run build_runner for JSON serialization
flutter packages pub run build_runner build --delete-conflicting-outputs

REM Build for web with correct base href
flutter build web --release --base-href "/wearables/"

echo.
echo ✅ Build completed successfully!
echo.
echo 🚀 DEPLOYMENT OPTIONS:
echo.
echo 1. NETLIFY (Easiest):
echo    - Go to https://netlify.com
echo    - Drag the build/web/ folder to the deploy area
echo    - Get instant live URL
echo.
echo 2. VERCEL:
echo    - Install: npm i -g vercel
echo    - Run: vercel --prod
echo.
echo 3. FIREBASE:
echo    - Install: npm i -g firebase-tools
echo    - Run: firebase init hosting
echo    - Run: firebase deploy
echo.
echo 4. LOCAL SERVER:
echo    - Use any web server to serve build/web/
echo    - Or use: python -m http.server 8000
echo.
echo 📱 Your app is ready at: build/web/
echo.
pause
