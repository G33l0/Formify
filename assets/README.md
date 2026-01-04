# Assets Directory

This directory contains all static assets for the Formify app.

## Directory Structure

```
assets/
├── fonts/          # Font files
├── images/         # App images and illustrations
├── icons/          # App icons and small graphics
└── templates/      # Document templates (if needed)
```

## Required Assets

### Fonts

Download Poppins font family from Google Fonts:
https://fonts.google.com/specimen/Poppins

Required files:
- `fonts/Poppins-Regular.ttf`
- `fonts/Poppins-Medium.ttf`
- `fonts/Poppins-SemiBold.ttf`
- `fonts/Poppins-Bold.ttf`

These are already configured in `pubspec.yaml`.

### App Icon

Create app icons for multiple resolutions:

**For Android:**
- mipmap-mdpi: 48x48
- mipmap-hdpi: 72x72
- mipmap-xhdpi: 96x96
- mipmap-xxhdpi: 144x144
- mipmap-xxxhdpi: 192x192

**For iOS:**
- Various sizes from 20x20 to 1024x1024

**Recommended Tool:**
Use the `flutter_launcher_icons` package to automatically generate icons from a single source image.

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
```

2. Run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Optional Images

You can add these optional images:

- `images/onboarding_1.png` - Onboarding illustration 1
- `images/onboarding_2.png` - Onboarding illustration 2
- `images/onboarding_3.png` - Onboarding illustration 3
- `images/empty_state.png` - Empty state illustration

## Image Guidelines

### File Formats
- **PNG** - For icons and images with transparency
- **JPG** - For photos and complex images
- **SVG** - For vector graphics (requires flutter_svg package)

### Image Sizes
- Keep images optimized for mobile (< 500KB each)
- Provide @2x and @3x versions for high-DPI screens
- Use appropriate compression

### Naming Convention
- Use lowercase
- Use underscores for spaces
- Be descriptive: `empty_state.png` not `img1.png`

## Usage in Code

### Using Images
```dart
Image.asset('assets/images/logo.png')
```

### Using Icons
```dart
Image.asset('assets/icons/custom_icon.png')
```

### Using Fonts
Fonts are configured globally in `pubspec.yaml` and used via theme.

## Creating Assets

### App Icon Design
- Size: 1024x1024px (square)
- Format: PNG with transparency
- Style: Modern, simple, recognizable at small sizes
- Colors: Use primary brand color (Royal Blue #246BFD)

**Icon Concept Ideas:**
1. Document with lightning bolt (speed/efficiency)
2. Stacked papers with checkmark
3. Stylized "F" lettermark
4. Paper with pen/signature

### Recommended Design Tools
- Figma (free online)
- Canva (free with templates)
- Adobe Illustrator
- Inkscape (free)

## Asset Optimization

Before adding assets, optimize them:

### For PNG
```bash
# Using ImageOptim (macOS)
imageoptim *.png

# Using pngquant
pngquant --quality=65-80 image.png
```

### For JPG
```bash
# Using jpegoptim
jpegoptim --max=85 image.jpg
```

## Placeholder Assets

If you don't have custom assets yet, the app will:
- Use system icons
- Use placeholder colors
- Show text-based empty states

The app is fully functional without custom assets.

## Notes

- Don't commit large binary files to git if possible
- Keep total assets under 10MB for faster app downloads
- Test assets on multiple screen sizes and densities
- Ensure assets work on both light and dark themes
