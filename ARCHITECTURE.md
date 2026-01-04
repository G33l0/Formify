# Formify - Architecture Guide

## Overview

Formify follows a **clean architecture** pattern with clear separation of concerns. The app is built using Flutter with Riverpod for state management, following MVVM (Model-View-ViewModel) principles.

## Architecture Layers

### 1. Presentation Layer (UI)
- **Location**: `lib/features/`
- **Responsibility**: UI components, screens, and user interaction
- **Pattern**: Feature-based organization
- Each feature has its own `screens/` and `widgets/` folder

### 2. Domain Layer (Business Logic)
- **Location**: `lib/providers/`
- **Responsibility**: State management, business rules
- **Pattern**: Riverpod StateNotifiers
- Handles all business logic and state transformations

### 3. Data Layer
- **Location**: `lib/models/` and `lib/core/database/`
- **Responsibility**: Data models and persistence
- **Pattern**: Repository pattern (simplified)
- SQLite for structured data, Hive for key-value storage

### 4. Service Layer
- **Location**: `lib/services/`
- **Responsibility**: External integrations (PDF, sharing, etc.)
- **Pattern**: Service classes with static methods

## Project Structure Explained

```
lib/
├── main.dart                          # Entry point, app initialization
│
├── core/                              # Core utilities and shared resources
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants (colors, limits, etc.)
│   ├── database/
│   │   └── database_helper.dart       # SQLite database singleton
│   ├── theme/
│   │   └── app_theme.dart             # Theme definitions (light/dark)
│   └── utils/
│       └── formatters.dart            # Utility functions (currency, dates)
│
├── models/                            # Data models (Plain Dart classes)
│   ├── business_profile.dart          # Business information model
│   ├── customer.dart                  # Customer information model
│   ├── document.dart                  # Main document model
│   ├── invoice_item.dart              # Invoice line item model
│   └── resume_models.dart             # Resume-related models
│
├── providers/                         # Riverpod state management
│   ├── business_provider.dart         # Business CRUD operations
│   ├── customer_provider.dart         # Customer CRUD operations
│   ├── document_provider.dart         # Document CRUD operations
│   ├── premium_provider.dart          # Premium subscription state
│   ├── settings_provider.dart         # App settings (currency, language)
│   └── theme_provider.dart            # Theme switching state
│
├── features/                          # Feature modules (by screen/function)
│   ├── onboarding/
│   │   └── screens/
│   │       ├── splash_screen.dart     # Initial splash screen
│   │       └── onboarding_screen.dart # Welcome slides
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart       # Main dashboard
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
│   └── widgets/                       # Shared UI components
│       └── custom_text_field.dart
│
└── services/                          # External services
    └── pdf_service.dart               # PDF generation logic
```

## Data Flow

```
User Action (UI)
    ↓
ConsumerWidget reads/writes Provider
    ↓
StateNotifier (Provider) processes logic
    ↓
Database Helper (SQLite/Hive)
    ↓
Update State
    ↓
UI Rebuilds (Riverpod auto-rebuild)
```

## State Management Pattern

### Riverpod Providers

We use several types of Riverpod providers:

1. **StateNotifierProvider** - For complex state with methods
   ```dart
   final documentsProvider = StateNotifierProvider<DocumentsNotifier, List<Document>>((ref) {
     return DocumentsNotifier(ref);
   });
   ```

2. **StateProvider** - For simple state
   ```dart
   final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
     return CurrencyNotifier();
   });
   ```

### State Notifiers

Each StateNotifier follows this pattern:
- Extends `StateNotifier<T>`
- Initializes with default state
- Provides methods to update state
- Persists to database/storage
- Notifies listeners automatically

Example:
```dart
class DocumentsNotifier extends StateNotifier<List<Document>> {
  DocumentsNotifier(this.ref) : super([]) {
    loadDocuments();
  }

  final Ref ref;
  final _db = DatabaseHelper.instance;

  Future<void> loadDocuments() async {
    final maps = await _db.queryAll('documents');
    state = maps.map((map) => Document.fromMap(map)).toList();
  }

  Future<void> addDocument(Document document) async {
    await _db.insert('documents', document.toMap());
    await loadDocuments();
  }
}
```

## Database Schema

### SQLite Tables

1. **business_profiles**
   - id (TEXT PRIMARY KEY)
   - name, email, phone, address, city, country
   - taxId, logo, isDefault
   - createdAt

2. **customers**
   - id (TEXT PRIMARY KEY)
   - name, email, phone, address, city, country
   - taxId
   - createdAt

3. **documents**
   - id (TEXT PRIMARY KEY)
   - type (enum as string)
   - documentNumber, title
   - data (JSON string)
   - totalAmount, currency
   - createdAt, updatedAt

4. **templates**
   - id (TEXT PRIMARY KEY)
   - type, name
   - data (JSON string)
   - isPremium
   - createdAt

### Hive Boxes

1. **settings** - App preferences
   - themeMode
   - currency
   - language
   - hasSeenOnboarding

2. **premium** - Premium status
   - isPremium
   - purchaseDate

## Document Model Design

The `Document` model uses a flexible JSON `data` field to store type-specific information:

```dart
class Document {
  final String id;
  final DocumentType type;
  final String documentNumber;
  final String title;
  final Map<String, dynamic> data;  // Flexible data storage
  final double totalAmount;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

**Example data structures:**

**Invoice:**
```json
{
  "businessId": "...",
  "customerId": "...",
  "invoiceDate": "2024-01-01",
  "dueDate": "2024-01-31",
  "items": [...],
  "taxPercent": 10,
  "discountPercent": 5,
  "subtotal": 1000,
  "taxAmount": 100,
  "discountAmount": 50,
  "notes": "..."
}
```

**Resume:**
```json
{
  "fullName": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "summary": "...",
  "experiences": [...],
  "educations": [...],
  "skills": [...]
}
```

This design allows flexibility for different document types while maintaining a single table.

## PDF Generation

The PDF generation follows a factory-like pattern:

```
Document → PdfService.generateXXXPDF() → PDF File → Share/Print
```

Each document type has its own PDF generator:
- `generateInvoicePDF()`
- `generateReceiptPDF()`
- `generateResumePDF()`
- `generateGenericPDF()`

PDFs are generated using the `pdf` package and can be:
- Saved to device
- Shared via `share_plus`
- Printed via `printing`

## Premium Feature Architecture

Premium status is managed via `PremiumNotifier`:

```dart
// Check premium status
final isPremium = ref.watch(isPremiumProvider);

// In UI
if (!isPremium) {
  // Show upgrade prompt or add watermark
}
```

Premium features:
- Watermark removal (checked in PDF generation)
- Document limits (checked before save)
- Logo upload (checked in business profile)
- Premium templates (filtered by isPremium flag)

## Navigation

Simple push-based navigation:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => SomeScreen()),
);
```

For future scaling, consider using:
- `go_router` for declarative routing
- Deep linking support
- Route guards for premium features

## Error Handling

Current approach:
- Try-catch blocks in async operations
- User feedback via SnackBar
- Default values in data parsing

Recommended additions:
- Global error handler
- Error logging service
- Retry mechanisms
- Offline queue for failed operations

## Performance Considerations

### Current Optimizations
1. **Lazy Loading**: Documents loaded on-demand
2. **Indexed Database**: Primary keys on all tables
3. **Provider Scoping**: Minimal rebuilds with Riverpod
4. **Image Optimization**: Logos stored as paths, not full data

### Future Optimizations
1. **Pagination**: For large document lists
2. **Caching**: Cache frequently accessed data
3. **Background Processing**: For PDF generation
4. **Debouncing**: For search/filter operations

## Testing Strategy

### Unit Tests
- Test StateNotifiers independently
- Mock database with fake implementation
- Test data transformations

### Widget Tests
- Test individual screens
- Mock providers with Riverpod testing utilities
- Verify UI state changes

### Integration Tests
- Test complete user flows
- Database integration
- PDF generation

## Security Considerations

1. **Local Storage**: All data stored locally, no cloud sync
2. **Sensitive Data**: No passwords or payment info stored
3. **GDPR Compliance**: User owns all data, can delete app to remove
4. **Input Validation**: Validate all user inputs
5. **SQL Injection**: Using parameterized queries

## Build & Deployment

### Debug Build
```bash
flutter run
```

### Release Build
```bash
flutter build apk --release
flutter build appbundle --release  # For Play Store
flutter build ios --release
```

### Environment Variables
For production, consider using:
- Different AdMob IDs per environment
- Feature flags
- API endpoints (if adding backend)

## Future Architecture Improvements

1. **Dependency Injection**: Consider `get_it` for better testability
2. **Repository Pattern**: Formal repository layer
3. **Use Cases**: Separate business logic into use case classes
4. **API Layer**: If adding cloud sync
5. **Offline-First Sync**: Sync queue with conflict resolution
6. **Modular Architecture**: Feature modules as packages
7. **Code Generation**: More use of code gen for boilerplate

## Dependencies Overview

### Core
- `flutter_riverpod` - State management
- `sqflite` - Local database
- `hive` - Key-value storage
- `path_provider` - File system access

### UI/UX
- `google_fonts` - Typography
- `flutter_svg` - Vector graphics (if needed)

### Utilities
- `intl` - Internationalization & formatting
- `uuid` - Unique ID generation
- `share_plus` - Share functionality
- `url_launcher` - Open URLs

### PDF & Printing
- `pdf` - PDF creation
- `printing` - PDF preview & print

### Monetization
- `google_mobile_ads` - AdMob integration
- `in_app_purchase` - IAP handling

### Dev Dependencies
- `flutter_lints` - Linting rules
- `build_runner` - Code generation
- `riverpod_generator` - Provider code gen
- `hive_generator` - Hive adapters

## Conclusion

This architecture prioritizes:
- **Simplicity**: Easy to understand and maintain
- **Scalability**: Can grow with new features
- **Offline-First**: Works without internet
- **Clean Code**: Separation of concerns
- **Performance**: Fast and responsive

For questions or suggestions, please refer to the main README or open an issue.
