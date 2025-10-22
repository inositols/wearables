# Deployment Instructions

## Local Development
```bash
# Install dependencies
flutter pub get

# Run the app locally
flutter run -d web-server --web-port 8080
```

## Production Build
```bash
# Build for web
flutter build web --release

# The built files will be in build/web/
# Upload this folder to your hosting service
```

## Hosting Options

### GitHub Pages
1. Build the app: `flutter build web --release`
2. Copy `build/web/*` to your GitHub Pages repository
3. Push to deploy

### Netlify
1. Connect your GitHub repository
2. Set build command: `flutter build web --release`
3. Set publish directory: `build/web`

### Vercel
1. Connect your GitHub repository
2. Set build command: `flutter build web --release`
3. Set output directory: `build/web`

### Firebase Hosting
1. Install Firebase CLI
2. Run `firebase init hosting`
3. Set public directory to `build/web`
4. Run `flutter build web --release`
5. Run `firebase deploy`

## Demo URL
Once deployed, your app will be available at your hosting service URL.

## Features to Demonstrate
1. **Load Data**: Shows loading skeleton with simulated latency
2. **Range Switching**: Switch between 7d/30d/90d views
3. **Pan/Zoom**: Interactive chart exploration
4. **Tooltip Sync**: Hover over charts to see synchronized tooltips
5. **Annotation Tap**: Click on mood markers to see journal entries
6. **Error/Retry**: Simulated network failures with retry
7. **Large Dataset**: Toggle performance mode for 10k+ points
8. **Dark Mode**: Toggle between light and dark themes
9. **Mobile Responsive**: Test at 375px width

