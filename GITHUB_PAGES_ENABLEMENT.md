# GitHub Pages Enablement Guide

## 🚨 **Issue: GitHub Pages Not Enabled**

The error "Get Pages site failed" means GitHub Pages is not enabled in your repository. Here's how to fix it:

## 🔧 **Step-by-Step Setup**

### **1. Enable GitHub Pages**
1. Go to your GitHub repository: `https://github.com/inositols/wearables`
2. Click **Settings** tab (top right of repository)
3. Scroll down to **Pages** section in the left sidebar
4. Under **Source**, select **GitHub Actions**
5. Click **Save**

### **2. Verify Pages Configuration**
- **Source**: GitHub Actions ✅
- **Branch**: Will be set automatically
- **Custom Domain**: Leave empty (optional)

### **3. Check Repository Permissions**
1. Go to **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, select:
   - **Read and write permissions** ✅
   - **Allow GitHub Actions to create and approve pull requests** ✅

## 📋 **Alternative: Manual Setup**

If the above doesn't work, try this manual approach:

### **Option 1: Use gh-pages Branch**
1. Create a new branch called `gh-pages`
2. Push your built files to this branch
3. Set Pages source to `gh-pages` branch

### **Option 2: Use Netlify (Recommended)**
1. Go to [netlify.com](https://netlify.com)
2. Drag and drop your `build/web` folder
3. Get instant deployment URL

## 🚀 **Quick Fix Commands**

### **Build and Deploy Locally:**
```bash
# Build the app
flutter build web --release --base-href "/wearables/"

# The built files are in build/web/
# You can now deploy this folder to any hosting service
```

### **Deploy to Netlify (Easiest):**
1. Build the app: `flutter build web --release --base-href "/wearables/"`
2. Go to [netlify.com](https://netlify.com)
3. Drag the `build/web` folder to the deploy area
4. Get your live URL instantly

## 🔍 **Verify Setup**

### **Check These Settings:**
- ✅ **Repository**: `https://github.com/inositols/wearables`
- ✅ **Settings** → **Pages** → **Source**: GitHub Actions
- ✅ **Settings** → **Actions** → **General** → **Workflow permissions**: Read and write
- ✅ **Actions** tab shows workflow runs

## 📱 **Expected Results**

Once GitHub Pages is enabled:
- ✅ **GitHub Actions** will deploy successfully
- ✅ **Live Demo** will be available at `https://inositols.github.io/wearables/`
- ✅ **All Features** will work (pan/zoom, tooltips, annotations)
- ✅ **Mobile** responsive design

## 🚨 **Troubleshooting**

### **If GitHub Pages Still Doesn't Work:**
1. **Check Repository Settings**: Ensure Pages is enabled
2. **Check Permissions**: Ensure Actions can write to Pages
3. **Check Workflow**: Ensure the workflow is running
4. **Use Alternative**: Deploy to Netlify or Vercel

### **Alternative Deployment Options:**
1. **Netlify**: Drag `build/web/` to netlify.com
2. **Vercel**: Use `vercel --prod`
3. **Firebase**: Use Firebase Hosting
4. **Local Server**: Serve `build/web/` locally

## 🎯 **Success Indicators**

- ✅ **GitHub Pages**: Enabled in repository settings
- ✅ **Actions**: Can write to Pages
- ✅ **Workflow**: Runs successfully
- ✅ **Live Demo**: Accessible via GitHub Pages URL

**Follow these steps to enable GitHub Pages and get your live demo working!** 🚀
