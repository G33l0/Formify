import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/document.dart';
import '../../../providers/document_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';

class DocumentListScreen extends ConsumerStatefulWidget {
  const DocumentListScreen({super.key});

  @override
  ConsumerState<DocumentListScreen> createState() =>
      _DocumentListScreenState();
}

class _DocumentListScreenState extends ConsumerState<DocumentListScreen> {
  String _searchQuery = '';
  DocumentType? _filterType;

  @override
  Widget build(BuildContext context) {
    final allDocuments = ref.watch(documentsProvider);
    final documents = _getFilteredDocuments(allDocuments);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Documents'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search documents...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filterType == null,
                  onSelected: (selected) {
                    setState(() {
                      _filterType = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...DocumentType.values.take(6).map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type.name),
                      selected: _filterType == type,
                      onSelected: (selected) {
                        setState(() {
                          _filterType = selected ? type : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Documents list
          Expanded(
            child: documents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return _buildDocumentCard(documents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Document> _getFilteredDocuments(List<Document> documents) {
    var filtered = documents;

    // Apply type filter
    if (_filterType != null) {
      filtered = filtered.where((doc) => doc.type == _filterType).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((doc) {
        return doc.title.toLowerCase().contains(query) ||
            doc.documentNumber.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  Widget _buildDocumentCard(Document doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForType(doc.type).withOpacity(0.1),
          child: Text(
            doc.type.icon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          doc.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doc.documentNumber),
            Text(
              Formatters.formatDate(doc.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (doc.totalAmount > 0)
              Text(
                Formatters.formatCurrency(doc.totalAmount, doc.currency),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) => _handleMenuAction(value, doc),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility_rounded),
                      SizedBox(width: 8),
                      Text('View'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.copy_rounded),
                      SizedBox(width: 8),
                      Text('Duplicate'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share_rounded),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No documents found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForType(DocumentType type) {
    switch (type) {
      case DocumentType.invoice:
        return AppTheme.primaryColor;
      case DocumentType.receipt:
        return AppTheme.secondaryColor;
      case DocumentType.quotation:
        return AppTheme.accentColor;
      case DocumentType.resume:
        return AppTheme.successColor;
      default:
        return AppTheme.infoColor;
    }
  }

  Future<void> _handleMenuAction(String action, Document doc) async {
    switch (action) {
      case 'view':
        // TODO: Implement document preview
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('View document - Coming soon')),
        );
        break;
      case 'duplicate':
        await ref.read(documentsProvider.notifier).duplicateDocument(doc);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document duplicated')),
          );
        }
        break;
      case 'share':
        // TODO: Implement share
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share - Coming soon')),
        );
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Document'),
            content: const Text('Are you sure you want to delete this document?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await ref.read(documentsProvider.notifier).deleteDocument(doc.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document deleted')),
            );
          }
        }
        break;
    }
  }
}
