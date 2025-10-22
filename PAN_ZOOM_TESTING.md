# Pan/Zoom Testing Guide

## 🎯 **How to Test Pan/Zoom Interactions**

### **1. Desktop Testing (Mouse)**
- **Pan**: Click and drag on any chart to move around the time axis
- **Zoom**: Use mouse wheel to zoom in/out on the data
- **Reset**: Double-click on the chart to reset zoom level
- **Hover**: Move mouse over chart to see tooltips

### **2. Mobile Testing (Touch)**
- **Pan**: Touch and drag to move around the time axis
- **Zoom**: Pinch gesture to zoom in/out
- **Reset**: Double-tap to reset zoom level
- **Tap**: Tap on chart to see tooltips

### **3. Browser DevTools Testing**
1. **Open DevTools**: Press F12 in browser
2. **Toggle Device Toolbar**: Click device icon
3. **Select Mobile**: Choose iPhone or Android
4. **Set Width**: 375px for mobile testing
5. **Test Touch**: Use touch gestures in DevTools

## 📱 **Testing Steps for Demo**

### **Step 1: Load Data**
- Wait for loading skeleton to complete
- Data should load with 90 days of biometric data

### **Step 2: Test Range Switching**
- Click "7d" button → charts show 7 days
- Click "30d" button → charts show 30 days  
- Click "90d" button → charts show 90 days
- All charts should update simultaneously

### **Step 3: Test Pan/Zoom**
- **Pan**: Click and drag on any chart to move through time
- **Zoom**: Use mouse wheel to zoom in/out
- **Synchronized**: All charts should pan/zoom together
- **Reset**: Double-click to reset zoom

### **Step 4: Test Tooltips**
- **Hover**: Move mouse over chart points
- **Synchronized**: All charts show same date tooltip
- **Journal Data**: Tooltips show mood and notes when available

### **Step 5: Test Annotations**
- **Mood Markers**: Look for colored vertical lines
- **Hover**: Hover over markers to see mood details
- **Colors**: Red (mood 1), Orange (mood 2), Yellow (mood 3), Green (mood 4-5)

### **Step 6: Test Performance**
- **Toggle**: Use menu → "Toggle Large Dataset"
- **Wait**: Let it load 10k+ data points
- **Pan/Zoom**: Should still be smooth with decimation

### **Step 7: Test Error Handling**
- **Simulate**: Use menu → "Simulate Error"
- **Retry**: Click retry button
- **Recovery**: Should load data successfully

### **Step 8: Test Mobile**
- **DevTools**: Press F12 → Toggle device toolbar
- **Mobile**: Select iPhone/Android, 375px width
- **Touch**: Test pan/zoom with touch gestures
- **Navigation**: Use bottom tabs on mobile

## 🎬 **Screen Recording Tips**

### **For Demo Recording:**
1. **Start with loading** - Show skeleton animation
2. **Range switching** - Click 7d → 30d → 90d buttons
3. **Pan/Zoom** - Drag to pan, wheel to zoom, double-click to reset
4. **Tooltips** - Hover over charts, show synchronized tooltips
5. **Annotations** - Point out mood markers, hover for details
6. **Mobile** - Switch to mobile view, test touch interactions
7. **Performance** - Toggle large dataset, show smooth performance
8. **Error** - Simulate error, show retry functionality

### **Key Features to Highlight:**
- ✅ **Synchronized charts** - All charts update together
- ✅ **Pan/Zoom** - Smooth data exploration
- ✅ **Tooltips** - Rich information on hover
- ✅ **Annotations** - Mood markers with journal data
- ✅ **Performance** - Handles 10k+ points smoothly
- ✅ **Mobile** - Responsive design for all screen sizes
- ✅ **Error handling** - Graceful failure recovery

## 🔧 **Troubleshooting**

### **If Pan/Zoom Not Working:**
- Check that `handleBuiltInTouches: true` is set
- Ensure charts have data loaded
- Try refreshing the page
- Check browser console for errors

### **If Charts Not Synchronized:**
- Verify all charts use the same `onDateSelected` callback
- Check that `selectedDate` is passed to all charts
- Ensure Provider state is updating correctly

### **If Mobile Not Responsive:**
- Use browser DevTools device simulation
- Check screen width detection (600px breakpoint)
- Verify mobile layout is being used

## 📊 **Expected Behavior**

### **Pan/Zoom Should:**
- Work smoothly on all charts
- Maintain synchronization across charts
- Show visual feedback during interaction
- Reset to original view when double-clicking
- Handle large datasets without lag

### **Tooltips Should:**
- Show on hover/touch
- Display synchronized date across all charts
- Include journal mood and notes when available
- Update in real-time during pan/zoom

### **Mobile Should:**
- Switch to tab-based navigation
- Use touch-optimized interactions
- Maintain all functionality
- Show appropriate layout for screen size
