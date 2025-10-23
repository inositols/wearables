# 🖱️ Pan/Zoom Testing Guide

## 🎯 **How to Test Pan/Zoom Without External Mouse**

### **✅ Touch Device Testing**

#### **📱 Mobile/Tablet Gestures**
- **Single Touch Pan**: Touch and drag to move around the chart
- **Pinch Zoom**: Use two fingers to pinch in/out for zoom
- **Double-tap Zoom**: Double-tap to zoom in on a specific area
- **Two-finger Pan**: Pan while zoomed in using two fingers

#### **💻 Trackpad Testing (Mac/Windows)**
- **Click & Drag**: Click and drag with one finger to pan
- **Pinch Gestures**: Use two fingers on trackpad to zoom
- **Scroll Zoom**: Use Ctrl+scroll wheel to zoom in/out
- **Two-finger Drag**: Pan around while zoomed in

### **✅ Browser DevTools Testing**

#### **🔧 Chrome DevTools Method**
1. **Open DevTools**: Press `F12` or `Ctrl+Shift+I`
2. **Toggle Device Toolbar**: Press `Ctrl+Shift+M` or click device icon
3. **Select Device**: Choose iPhone/Android from dropdown
4. **Test Touch**: Use mouse to simulate touch gestures
5. **Test Pan/Zoom**: 
   - Click and drag to pan
   - Hold Ctrl and scroll to zoom
   - Use two-finger gestures on trackpad

#### **📱 Device Simulation Steps**
```
1. Open your app in browser
2. Press F12 to open DevTools
3. Click the device toggle button (📱 icon)
4. Select "iPhone 12 Pro" or "Pixel 5"
5. Test touch interactions:
   - Click and drag to pan
   - Ctrl+scroll to zoom
   - Two-finger trackpad gestures
```

### **✅ Keyboard Testing**

#### **⌨️ Keyboard Navigation**
- **Arrow Keys**: Navigate around the chart
- **+/- Keys**: Zoom in/out (if implemented)
- **Page Up/Down**: Zoom levels
- **Home/End**: Reset zoom/pan
- **Space**: Pan mode toggle

### **✅ Testing Checklist**

#### **🎯 Pan Functionality**
- [ ] **Single Touch Pan**: Touch and drag moves chart
- [ ] **Smooth Movement**: No jerky or laggy panning
- [ ] **Boundary Handling**: Chart doesn't pan beyond data bounds
- [ ] **Multi-touch Pan**: Two-finger pan works
- [ ] **Keyboard Pan**: Arrow keys move chart

#### **🔍 Zoom Functionality**
- [ ] **Pinch Zoom**: Two-finger pinch zooms in/out
- [ ] **Scroll Zoom**: Mouse wheel or trackpad scroll zooms
- [ ] **Double-tap Zoom**: Double-tap zooms to specific area
- [ ] **Zoom Limits**: Reasonable min/max zoom levels
- [ ] **Zoom Center**: Zooms to cursor/touch point

#### **📊 Chart Interaction**
- [ ] **Tooltip Sync**: Hovering shows data points
- [ ] **Crosshair**: Vertical line follows cursor
- [ ] **Data Selection**: Clicking selects specific dates
- [ ] **Smooth Animation**: Transitions are smooth
- [ ] **Performance**: 60fps during interactions

### **✅ Testing on Different Devices**

#### **📱 Mobile Testing**
```bash
# Test on actual mobile device
flutter run -d chrome --web-port 8080
# Then open on mobile browser
```

#### **💻 Desktop Testing**
```bash
# Test with trackpad gestures
flutter run -d chrome --web-port 8080
# Use trackpad for pan/zoom
```

#### **🖥️ External Mouse Testing**
```bash
# If you have access to external mouse
flutter run -d chrome --web-port 8080
# Test with mouse wheel zoom and drag
```

### **✅ Debug Information**

#### **🔍 Console Logging**
Add these to your chart widget to debug pan/zoom:
```dart
// In SynchronizedChart widget
touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
  print('Touch event: $event');
  print('Touch response: $touchResponse');
  
  if (event is FlPanDownEvent) {
    print('Pan started');
  } else if (event is FlPanEndEvent) {
    print('Pan ended');
  }
},
```

#### **📊 Performance Monitoring**
```dart
// Monitor frame rate during pan/zoom
void _onPanZoom() {
  final stopwatch = Stopwatch()..start();
  // ... pan/zoom logic
  stopwatch.stop();
  print('Pan/zoom took: ${stopwatch.elapsedMilliseconds}ms');
}
```

### **✅ Common Issues & Solutions**

#### **❌ Pan Not Working**
- **Check**: `handleBuiltInTouches: true` is set
- **Check**: Touch events are properly handled
- **Check**: Chart bounds are correctly set

#### **❌ Zoom Not Working**
- **Check**: Zoom gestures are enabled
- **Check**: Min/max zoom limits are reasonable
- **Check**: Touch event handling is correct

#### **❌ Performance Issues**
- **Check**: Data decimation is working
- **Check**: Chart rendering is optimized
- **Check**: Animation frame rate is 60fps

### **✅ Testing Commands**

#### **🚀 Quick Test Setup**
```bash
# Run app for testing
flutter run -d chrome --web-port 8080

# Open in browser
# Press F12 for DevTools
# Press Ctrl+Shift+M for device mode
# Test pan/zoom functionality
```

#### **📱 Mobile Testing**
```bash
# Build for web
flutter build web

# Serve locally
python -m http.server 8000

# Open on mobile device
# Navigate to your local IP:8000
```

### **✅ Expected Behavior**

#### **🎯 Pan Functionality**
- **Smooth Movement**: Chart moves fluidly with touch/drag
- **Boundary Respect**: Doesn't pan beyond data limits
- **Multi-touch**: Two-finger pan works correctly
- **Performance**: 60fps during panning

#### **🔍 Zoom Functionality**
- **Pinch Zoom**: Two-finger pinch zooms in/out
- **Scroll Zoom**: Mouse wheel/trackpad scroll works
- **Zoom Center**: Zooms to cursor/touch point
- **Zoom Limits**: Reasonable min/max zoom levels

#### **📊 Chart Interaction**
- **Tooltip Sync**: Hovering shows data points
- **Crosshair**: Vertical line follows cursor
- **Data Selection**: Clicking selects specific dates
- **Smooth Animation**: Transitions are smooth

## 🎉 **Testing Complete!**

Your pan/zoom functionality should work perfectly with:
- ✅ **Touch gestures** on mobile/tablet
- ✅ **Trackpad gestures** on laptop
- ✅ **Mouse interactions** on desktop
- ✅ **Keyboard navigation** for accessibility
- ✅ **DevTools simulation** for testing

**Test all these methods to ensure your pan/zoom works flawlessly!** 🚀✨
