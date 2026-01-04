# Formify - Smart Documents & Receipts

**Create professional documents in seconds**

Formify is a production-ready cross-platform mobile app built with Flutter that enables users to create, manage, and export various business and personal documents including invoices, receipts, quotations, resumes, contracts, and more.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

### Document Types
- 📄 **Invoices** - Professional invoices with automatic calculations
- 🧾 **Receipts** - Quick payment receipts
- 💼 **Quotations** - Business quotes and estimates
- 📋 **Resumes/CV** - Professional resume builder
- ✉️ **Cover Letters** - Customizable cover letter templates
- 📝 **Contracts** - Simple contract templates
- 🏠 **Rental Agreements** - Lease agreement templates
- 📊 **Business Proposals** - Professional proposals
- ⏰ **Meeting Minutes** - Meeting documentation
- 💰 **Payment Reminders** - Payment follow-up letters
- 📨 **Generic Letters** - Multi-purpose letter templates

### Core Features
- ✅ **Smart Calculations** - Automatic totals, tax, and discount calculations
- ✅ **Auto Numbering** - Sequential document numbering (INV-0001, RCP-0001, etc.)
- ✅ **PDF Export** - Export all documents to PDF format
- ✅ **Share Documents** - Share via email, WhatsApp, or other apps
- ✅ **Document History** - Save and manage all your documents locally
- ✅ **Duplicate Documents** - Quickly create copies of existing documents
- ✅ **Multi-Currency** - Support for 30+ global currencies
- ✅ **Light & Dark Theme** - Beautiful themes for any preference
- ✅ **Offline First** - Works completely offline, no login required
- ✅ **Business Profiles** - Manage multiple business identities
- ✅ **Customer Management** - Save and reuse customer information

### Premium Features 💎
- Remove watermark from PDFs
- Unlimited document saves
- Upload custom logo
- Premium templates
- Multiple business profiles
- Cloud backup & sync (coming soon)
- Ad-free experience
- Priority support

## 📱 Screenshots

[Add your app screenshots here]

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/formify.git
   cd formify
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (for Riverpod and Hive)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Bundle will be at: `build/app/outputs/bundle/release/app-release.aab`

#### iOS
```bash
flutter build ios --release
```

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants
│   ├── database/
│   │   └── database_helper.dart       # SQLite database helper
│   ├── theme/
│   │   └── app_theme.dart             # App theming
│   └── utils/
│       └── formatters.dart            # Utility formatters
├── models/
│   ├── business_profile.dart          # Business profile model
│   ├── customer.dart                  # Customer model
│   ├── document.dart                  # Document model
│   ├── invoice_item.dart              # Invoice line item
│   └── resume_models.dart             # Resume-related models
├── providers/
│   ├── business_provider.dart         # Business state management
│   ├── customer_provider.dart         # Customer state management
│   ├── document_provider.dart         # Document state management
│   ├── premium_provider.dart          # Premium subscription state
│   ├── settings_provider.dart         # App settings state
│   └── theme_provider.dart            # Theme state
├── features/
│   ├── onboarding/
│   │   └── screens/
│   │       ├── splash_screen.dart
│   │       └── onboarding_screen.dart
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart
│   ├── documents/
│   │   └── screens/
│   │       ├── create_invoice_screen.dart
│   │       ├── create_receipt_screen.dart
│   │       ├── create_quote_screen.dart
│   │       ├── create_resume_screen.dart
│   │       ├── create_contract_screen.dart
│   │       └── document_list_screen.dart
│   ├── settings/
│   │   └── screens/
│   │       ├── settings_screen.dart
│   │       └── paywall_screen.dart
│   └── widgets/
│       └── custom_text_field.dart
└── services/
    └── pdf_service.dart               # PDF generation service
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Local Database**: SQLite (sqflite)
- **Local Storage**: Hive
- **PDF Generation**: pdf & printing packages
- **Monetization**: Google Mobile Ads & In-App Purchase
- **Utilities**: intl, uuid, share_plus, path_provider

## 💰 Monetization Setup

### AdMob Integration

1. Create an AdMob account at https://admob.google.com
2. Create an app in AdMob console
3. Get your Ad Unit IDs
4. Replace placeholder IDs in `lib/core/constants/app_constants.dart`:

```dart
static const String androidBannerAdId = 'YOUR_ANDROID_BANNER_ID';
static const String iosBannerAdId = 'YOUR_IOS_BANNER_ID';
```

### In-App Purchase Setup

1. **Android (Google Play)**
   - Set up Google Play Console
   - Create in-app products
   - Update product IDs in `app_constants.dart`

2. **iOS (App Store)**
   - Set up App Store Connect
   - Create in-app purchase products
   - Update product IDs in `app_constants.dart`

## 🎨 Customization

### Change Primary Color
Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF246BFD); // Your color
```

### Add New Currency
Add to `lib/core/constants/app_constants.dart`:
```dart
static const List<String> supportedCurrencies = [
  'USD', 'EUR', 'YOUR_CURRENCY'
];

static const Map<String, String> currencySymbols = {
  'YOUR_CURRENCY': 'SYMBOL',
};
```

### Modify Watermark
Edit in `lib/core/constants/app_constants.dart`:
```dart
static const String watermarkText = 'Your Custom Watermark';
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## 📝 TODO / Roadmap

- [ ] Add more document templates
- [ ] Implement cloud backup/sync
- [ ] Multi-language support (i18n)
- [ ] Email integration for sending documents
- [ ] Recurring invoices
- [ ] Payment tracking
- [ ] Reports and analytics
- [ ] Signature capture
- [ ] Tax calculator by region
- [ ] Export to Excel/CSV

## 🐛 Known Issues

- PDF preview not yet implemented (use export instead)
- Cloud sync is placeholder only
- Language selection is placeholder only
- Some templates need enhancement

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- All open-source contributors

## 📞 Support

For support, email support@formify.app or join our Slack channel.

---

**Made with ❤️ using Flutter**
