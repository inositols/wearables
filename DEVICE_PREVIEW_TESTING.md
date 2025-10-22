# Device Preview Testing Guide

## 📱 **Testing Pan/Zoom Interactions**

### **Method 1: Browser DevTools (Recommended)**

#### **Step 1: Open Your Live Demo**
1. Go to: `https://inositols.github.io/wearables/`
2. Press **F12** to open DevTools
3. Click the **device toolbar icon** (📱) or press **Ctrl+Shift+M**

#### **Step 2: Configure Mobile View**
1. **Select Device**: Choose iPhone 12 Pro or Pixel 5
2. **Set Width**: 375px (as required by assignment)
3. **Orientation**: Portrait for mobile testing

#### **Step 3: Test Pan/Zoom Interactions**
- **Pan**: Click and drag on charts to move through time
- **Zoom**: Use mouse wheel to zoom in/out
- **Touch Simulation**: DevTools simulates touch gestures
- **Reset**: Double-click to reset zoom level

### **Method 2: Local Development with Device Preview**

#### **Step 1: Run Local App**
```bash
flutter run -d web-server --web-port 8080
```

#### **Step 2: Open in Browser**
1. Go to: `http://localhost:8080`
2. Press **F12** → Device toolbar
3. Select mobile device (375px width)

#### **Step 3: Test Mobile Features**
- **Touch Gestures**: Pan with drag, zoom with pinch
- **Mobile Layout**: Should switch to tab-based navigation
- **Responsive Design**: Charts should adapt to mobile screen

### **Method 3: Real Mobile Device Testing**

#### **Step 1: Get Local Network URL**
```bash
# Find your local IP
ipconfig  # Windows
ifconfig  # Mac/Linux

# Use: http://YOUR_IP:8080
# Example: http://192.168.1.100:8080
```

#### **Step 2: Test on Mobile**
1. Connect mobile to same WiFi network
2. Open browser on mobile
3. Navigate to your local IP:8080
4. Test real touch interactions

## 🎯 **Pan/Zoom Testing Checklist**

### **✅ Desktop Testing**
- [ ] **Pan**: Click and drag on any chart
- [ ] **Zoom**: Mouse wheel to zoom in/out
- [ ] **Reset**: Double-click to reset zoom
- [ ] **Synchronized**: All charts move together
- [ ] **Visual Feedback**: Blue dots and lines appear

### **✅ Mobile Testing (375px)**
- [ ] **Touch Pan**: Touch and drag to move through time
- [ ] **Pinch Zoom**: Pinch gesture to zoom in/out
- [ ] **Reset**: Double-tap to reset zoom
- [ ] **Mobile Layout**: Tab-based navigation appears
- [ ] **Responsive**: Charts fit mobile screen

### **✅ Cross-Platform Testing**
- [ ] **Chrome**: Test in Chrome DevTools
- [ ] **Firefox**: Test in Firefox DevTools
- [ ] **Safari**: Test in Safari DevTools (Mac)
- [ ] **Edge**: Test in Edge DevTools

## 🔧 **Troubleshooting**

### **If Pan/Zoom Not Working:**
1. **Check Touch Events**: Ensure `handleBuiltInTouches: true` is set
2. **Verify Data**: Charts need data loaded to interact
3. **Browser Support**: Some browsers have different touch handling
4. **DevTools Mode**: Make sure device simulation is active

### **If Mobile Layout Not Appearing:**
1. **Screen Width**: Ensure width is exactly 375px
2. **Refresh**: Reload page after changing device settings
3. **Check Code**: Verify `MediaQuery.of(context).size.width < 600`

## 📱 **Expected Mobile Behavior**

### **375px Width (Mobile)**
- **Layout**: Tab-based navigation with bottom tabs
- **Charts**: Single chart per tab (HRV, RHR, Steps)
- **Touch**: Optimized for touch interactions
- **Navigation**: Swipe between chart tabs

### **Desktop Width (>600px)**
- **Layout**: All three charts stacked vertically
- **Mouse**: Mouse wheel zoom and click-drag pan
- **Synchronized**: All charts update together
- **Full Features**: All interactions available

## 🎬 **Demo Recording Tips**

### **For Screen Recording:**
1. **Start with Desktop**: Show full dashboard
2. **Switch to Mobile**: Use DevTools to show 375px
3. **Test Touch**: Demonstrate pan/zoom on mobile
4. **Show Synchronization**: All charts move together
5. **Highlight Features**: Point out mobile-specific features

### **Key Features to Highlight:**
- ✅ **Responsive Design**: Desktop → Mobile transition
- ✅ **Touch Interactions**: Pan/zoom on mobile
- ✅ **Synchronized Charts**: All charts update together
- ✅ **Mobile Navigation**: Tab-based interface
- ✅ **Performance**: Smooth interactions on mobile

## 🚀 **Quick Test Commands**

### **Local Testing:**
```bash
# Run app locally
flutter run -d web-server --web-port 8080

# Open in browser with DevTools
# Press F12 → Device toolbar → 375px width
```

### **Live Demo Testing:**
```
# Go to live demo
https://inositols.github.io/wearables/

# Open DevTools (F12)
# Select mobile device (375px)
# Test pan/zoom interactions
```

**Your Flutter Biometrics Dashboard is fully responsive and ready for mobile testing!** 📱✨
