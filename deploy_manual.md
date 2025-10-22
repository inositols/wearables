# Manual Deployment Guide

If GitHub Actions fails, you can deploy manually using these steps:

## 🚀 **Manual Deployment Steps**

### **1. Build Locally**
```bash
flutter build web --release --base-href "/wearables/"
```

### **2. Deploy to GitHub Pages**

#### **Option A: Using GitHub CLI**
```bash
# Install GitHub CLI if not installed
# Then run:
gh-pages -d build/web -b gh-pages
```

#### **Option B: Using Git**
```bash
# Create orphan branch
git checkout --orphan gh-pages

# Remove all files except build/web
git rm -rf .
cp -r build/web/* .
rm -rf build/

# Add and commit
git add .
git commit -m "Deploy Flutter Web App"

# Push to gh-pages branch
git push origin gh-pages --force
```

#### **Option C: Using Netlify Drop**
1. Go to [netlify.com](https://netlify.com)
2. Drag and drop the `build/web` folder
3. Get instant deployment URL

#### **Option D: Using Vercel**
1. Install Vercel CLI: `npm i -g vercel`
2. Run: `vercel --prod` in project root
3. Follow prompts for deployment

## 🔧 **Troubleshooting**

### **If GitHub Actions Still Fails:**
1. Check the Actions tab in your GitHub repository
2. Look for error messages in the workflow logs
3. Try the manual deployment methods above

### **If Build Fails Locally:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter build web --release --base-href "/wearables/"
```

### **If Base Path Issues:**
- Make sure `--base-href "/wearables/"` matches your repository name
- Update the base href in `index.html` if needed

## 📱 **Testing Deployment**

Once deployed, test:
1. **Desktop**: Full functionality with mouse interactions
2. **Mobile**: Use browser DevTools to test responsive design
3. **Features**: Pan/zoom, tooltips, annotations, range switching
4. **Performance**: Large dataset toggle, smooth interactions

## 🎯 **Expected Results**

- ✅ **Live Demo**: Accessible via GitHub Pages URL
- ✅ **Responsive**: Works on desktop and mobile
- ✅ **Interactive**: Pan/zoom, tooltips, annotations
- ✅ **Performance**: Handles large datasets smoothly
- ✅ **Error Handling**: Graceful failure recovery
