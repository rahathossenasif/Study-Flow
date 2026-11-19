# StudyFlow - Study Companion App

Beautiful dark-themed study app with multiple themes and bilingual support (English + বাংলা).

## Features
- Home dashboard with progress & subjects
- Syllabus tracker
- Focus Timer (Pomodoro)
- Notes
- Study Circle
- 4 Themes: Dark, Light, Premium Dark, System
- Language: English & বাংলা

## How to use on Android

### Option 1: Install as PWA (Recommended - Easy)
1. Open `index.html` in Chrome on your Android phone
2. Tap the menu (⋮) → **Add to Home screen** / **Install app**
3. The app will appear on your home screen like a normal app

### Option 2: Build APK using GitHub + PWABuilder / Capacitor
1. Upload this folder to a GitHub repository
2. Go to https://www.pwabuilder.com
3. Enter your GitHub Pages URL or hosted URL
4. Click **Build My PWA** → Download Android package
5. Or use Capacitor:
   ```bash
   npm install @capacitor/core @capacitor/cli @capacitor/android
   npx cap init StudyFlow com.studyflow.app
   npx cap add android
   npx cap sync
   npx cap open android
   ```

## Files
- `index.html` - Main app
- `manifest.json` - PWA manifest
- `README.md` - This file

## Credits
UI inspired by modern study app designs. Built for learning purposes.
