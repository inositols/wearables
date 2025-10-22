# Deploy to GitHub Pages - Step by Step Guide

## 🚀 **Quick Deployment (Automated)**

### Step 1: Enable GitHub Pages
1. Go to your repository on GitHub
2. Click **Settings** tab
3. Scroll down to **Pages** section
4. Under **Source**, select **GitHub Actions**
5. Save the settings

### Step 2: Push Your Code
```bash
# Add all files to git
git add .

# Commit your changes
git commit -m "Add Flutter Biometrics Dashboard"

# Push to main branch (this will trigger deployment)
git push origin main
```

### Step 3: Monitor Deployment
1. Go to **Actions** tab in your GitHub repository
2. Watch the "Deploy Flutter Web to GitHub Pages" workflow
3. Wait for it to complete (usually 2-3 minutes)

### Step 4: Access Your App
Your app will be available at:
```
https://[your-username].github.io/wearables/
```

---

## 🛠️ **Manual Deployment (Alternative)**

If you prefer manual deployment:

### Step 1: Build the App
```bash
# Install dependencies
flutter pub get

# Build for web
flutter build web --release --base-href "/wearables/"
```

### Step 2: Create gh-pages Branch
```bash
# Create and switch to gh-pages branch
git checkout --orphan gh-pages

# Remove all files
git rm -rf .

# Copy built files
cp -r build/web/* .

# Add and commit
git add .
git commit -m "Deploy Flutter Biometrics Dashboard"

# Push to gh-pages branch
git push origin gh-pages
```

### Step 3: Configure GitHub Pages
1. Go to repository **Settings** → **Pages**
2. Under **Source**, select **Deploy from a branch**
3. Select **gh-pages** branch and **/ (root)** folder
4. Click **Save**

---

## 🔧 **Troubleshooting**

### Common Issues:

#### 1. **404 Error**
- Make sure the base-href is set correctly: `--base-href "/wearables/"`
- Check that your repository name is "wearables"

#### 2. **Build Fails**
- Ensure Flutter is properly installed
- Check that all dependencies are in pubspec.yaml
- Run `flutter doctor` to check for issues

#### 3. **Assets Not Loading**
- Verify assets are in the `assets/` folder
- Check that `pubspec.yaml` includes the assets section

#### 4. **GitHub Actions Not Running**
- Make sure the workflow file is in `.github/workflows/`
- Check that you have push permissions to the repository
- Verify the branch name matches (main or master)

### Debug Commands:
```bash
# Check Flutter installation
flutter doctor

# Clean and rebuild
flutter clean
flutter pub get
flutter build web --release

# Test locally
flutter run -d web-server --web-port 8080
```

---

## 📱 **Testing Your Deployment**

Once deployed, test these features:

1. **Load Data**: Should show loading skeleton
2. **Range Switching**: 7d/30d/90d buttons
3. **Chart Interactions**: Hover for tooltips
4. **Dark Mode**: Toggle theme
5. **Performance Toggle**: Large dataset mode
6. **Mobile Responsive**: Test at 375px width
7. **Error Handling**: Simulated network failures

---

## 🌐 **Custom Domain (Optional)**

To use a custom domain:

1. Add a `CNAME` file to your repository root:
```
your-domain.com
```

2. Update the GitHub Pages settings:
   - Go to Settings → Pages
   - Add your custom domain
   - Enable "Enforce HTTPS"

3. Update the workflow file to include your domain in the cname field

---

## 📊 **Performance Monitoring**

Your deployed app includes:
- **Performance optimization** for large datasets
- **Responsive design** for mobile and desktop
- **Error handling** with retry functionality
- **Loading states** for better UX

The app is optimized for:
- **<16ms per frame** rendering
- **10k+ data points** handling
- **Mobile-first** responsive design
- **Cross-browser** compatibility

---

## 🎯 **Final Checklist**

Before deploying, ensure:
- [ ] All files are committed to git
- [ ] Flutter app builds successfully locally
- [ ] GitHub Pages is enabled in repository settings
- [ ] Workflow file is in `.github/workflows/`
- [ ] Base href is set correctly for your repository name
- [ ] Assets are properly configured in pubspec.yaml

Your Flutter Biometrics Dashboard will be live at:
**https://[your-username].github.io/wearables/**

🎉 **Congratulations!** Your interactive biometrics dashboard is now live on the web!
