import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/document.dart';
import '../../../providers/document_provider.dart';
import '../../../providers/premium_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../documents/screens/document_list_screen.dart';
import '../../documents/screens/create_invoice_screen.dart';
import '../../documents/screens/create_receipt_screen.dart';
import '../../documents/screens/create_quote_screen.dart';
import '../../documents/screens/create_resume_screen.dart';
import '../../documents/screens/create_contract_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../settings/screens/paywall_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load documents when home screen initializes
    Future.microtask(() {
      ref.read(documentsProvider.notifier).loadDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentsProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final recentDocuments = documents.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formify'),
        actions: [
          if (!isPremium)
            IconButton(
              icon: const Icon(Icons.workspace_premium_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaywallScreen()),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'What would you like to create?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),

            // Document type grid
            _buildDocumentTypeGrid(context),

            const SizedBox(height: 30),

            // Recent documents section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Documents',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DocumentListScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (recentDocuments.isEmpty)
              _buildEmptyState()
            else
              ...recentDocuments.map((doc) => _buildDocumentCard(doc)),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeGrid(BuildContext context) {
    final documentTypes = [
      _DocumentType(
        type: DocumentType.invoice,
        icon: Icons.receipt_long_rounded,
        color: AppTheme.primaryColor,
      ),
      _DocumentType(
        type: DocumentType.receipt,
        icon: Icons.receipt_rounded,
        color: AppTheme.secondaryColor,
      ),
      _DocumentType(
        type: DocumentType.quotation,
        icon: Icons.request_quote_rounded,
        color: AppTheme.accentColor,
      ),
      _DocumentType(
        type: DocumentType.resume,
        icon: Icons.person_rounded,
        color: AppTheme.successColor,
      ),
      _DocumentType(
        type: DocumentType.contract,
        icon: Icons.description_rounded,
        color: AppTheme.warningColor,
      ),
      _DocumentType(
        type: DocumentType.coverLetter,
        icon: Icons.mail_rounded,
        color: AppTheme.infoColor,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: documentTypes.length,
      itemBuilder: (context, index) {
        final docType = documentTypes[index];
        return _buildDocumentTypeCard(docType);
      },
    );
  }

  Widget _buildDocumentTypeCard(_DocumentType docType) {
    return InkWell(
      onTap: () => _navigateToCreateScreen(docType.type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: docType.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: docType.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              docType.icon,
              size: 40,
              color: docType.color,
            ),
            const SizedBox(height: 8),
            Text(
              docType.type.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: docType.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateScreen(DocumentType type) {
    Widget screen;
    switch (type) {
      case DocumentType.invoice:
        screen = const CreateInvoiceScreen();
        break;
      case DocumentType.receipt:
        screen = const CreateReceiptScreen();
        break;
      case DocumentType.quotation:
        screen = const CreateQuoteScreen();
        break;
      case DocumentType.resume:
        screen = const CreateResumeScreen();
        break;
      case DocumentType.contract:
      case DocumentType.coverLetter:
        screen = CreateContractScreen(type: type);
        break;
      default:
        screen = const CreateInvoiceScreen();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildDocumentCard(Document doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Text(
            doc.type.icon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          doc.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(doc.documentNumber),
        trailing: Text(
          doc.totalAmount > 0
              ? AppConstants.currencySymbols[doc.currency]! +
                  doc.totalAmount.toStringAsFixed(2)
              : '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // Navigate to document preview
          // TODO: Implement document preview screen
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No documents yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first document to get started',
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentType {
  final DocumentType type;
  final IconData icon;
  final Color color;

  _DocumentType({
    required this.type,
    required this.icon,
    required this.color,
  });
}
