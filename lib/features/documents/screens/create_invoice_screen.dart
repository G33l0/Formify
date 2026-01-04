import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/document.dart';
import '../../../models/invoice_item.dart';
import '../../../models/customer.dart';
import '../../../models/business_profile.dart';
import '../../../providers/document_provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../providers/business_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../services/pdf_service.dart';
import '../../widgets/custom_text_field.dart';

class CreateInvoiceScreen extends ConsumerStatefulWidget {
  final Document? existingDocument;

  const CreateInvoiceScreen({super.key, this.existingDocument});

  @override
  ConsumerState<CreateInvoiceScreen> createState() =>
      _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends ConsumerState<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  Customer? _selectedCustomer;
  BusinessProfile? _selectedBusiness;
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  List<InvoiceItem> _items = [];
  double _taxPercent = 0.0;
  double _discountPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _titleController.text = 'Invoice';
    _items.add(InvoiceItem(description: '', quantity: 1, rate: 0.0));

    // Load default business profile
    Future.microtask(() {
      final business = ref.read(businessProfilesProvider.notifier).defaultProfile;
      if (business != null) {
        setState(() => _selectedBusiness = business);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get _discountAmount {
    return _subtotal * (_discountPercent / 100);
  }

  double get _taxableAmount {
    return _subtotal - _discountAmount;
  }

  double get _taxAmount {
    return _taxableAmount * (_taxPercent / 100);
  }

  double get _total {
    return _taxableAmount + _taxAmount;
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _saveInvoice,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            CustomTextField(
              controller: _titleController,
              label: 'Invoice Title',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Business Profile
            _buildBusinessSelector(),
            const SizedBox(height: 16),

            // Customer
            _buildCustomerSelector(),
            const SizedBox(height: 16),

            // Dates
            Row(
              children: [
                Expanded(child: _buildDateField('Invoice Date', _invoiceDate, (date) {
                  setState(() => _invoiceDate = date);
                })),
                const SizedBox(width: 16),
                Expanded(child: _buildDateField('Due Date', _dueDate, (date) {
                  setState(() => _dueDate = date);
                })),
              ],
            ),
            const SizedBox(height: 24),

            // Items section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Items list
            ..._buildItemsList(),

            const SizedBox(height: 24),

            // Tax and discount
            _buildTaxDiscountFields(),

            const SizedBox(height: 24),

            // Totals
            _buildTotalsCard(currency),

            const SizedBox(height: 16),

            // Notes
            CustomTextField(
              controller: _notesController,
              label: 'Notes (optional)',
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveInvoice,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previewPDF,
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('Preview PDF'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessSelector() {
    final businesses = ref.watch(businessProfilesProvider);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.business_rounded),
        title: Text(_selectedBusiness?.name ?? 'Select Business'),
        subtitle: _selectedBusiness != null
            ? Text(_selectedBusiness!.email ?? '')
            : null,
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () async {
          // Show business selection dialog
          // For now, use default
        },
      ),
    );
  }

  Widget _buildCustomerSelector() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person_rounded),
        title: Text(_selectedCustomer?.name ?? 'Select Customer'),
        subtitle: _selectedCustomer != null
            ? Text(_selectedCustomer!.email ?? '')
            : null,
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          // Show customer selection dialog
          _showCustomerPicker();
        },
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd/MM/yyyy').format(date)),
            const Icon(Icons.calendar_today_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemsList() {
    return List.generate(_items.length, (index) {
      return _buildItemRow(index);
    });
  }

  Widget _buildItemRow(int index) {
    final item = _items[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Item ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (_items.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => _removeItem(index),
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: item.description,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _items[index] = item.copyWith(description: value);
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: item.quantity.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _items[index] = item.copyWith(
                          quantity: Formatters.parseInt(value),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: item.rate.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Rate',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _items[index] = item.copyWith(
                          rate: Formatters.parseDouble(value),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          item.subtotal.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxDiscountFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _taxPercent.toString(),
            decoration: const InputDecoration(
              labelText: 'Tax %',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _taxPercent = Formatters.parseDouble(value);
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            initialValue: _discountPercent.toString(),
            decoration: const InputDecoration(
              labelText: 'Discount %',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _discountPercent = Formatters.parseDouble(value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsCard(String currency) {
    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTotalRow('Subtotal', _subtotal, currency),
            if (_discountPercent > 0) ...[
              const SizedBox(height: 8),
              _buildTotalRow('Discount ($_discountPercent%)', -_discountAmount, currency),
            ],
            if (_taxPercent > 0) ...[
              const SizedBox(height: 8),
              _buildTotalRow('Tax ($_taxPercent%)', _taxAmount, currency),
            ],
            const Divider(height: 24),
            _buildTotalRow('Total', _total, currency, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, String currency, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          Formatters.formatCurrency(amount, currency),
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _addItem() {
    setState(() {
      _items.add(InvoiceItem(description: '', quantity: 1, rate: 0.0));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _showCustomerPicker() async {
    final customers = ref.read(customersProvider);

    final selected = await showDialog<Customer>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Customer'),
          content: SizedBox(
            width: double.maxFinite,
            child: customers.isEmpty
                ? const Text('No customers yet. Add a customer first.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return ListTile(
                        title: Text(customer.name),
                        subtitle: Text(customer.email ?? ''),
                        onTap: () => Navigator.pop(context, customer),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedCustomer = selected);
    }
  }

  Future<void> _saveInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }

    final currency = ref.read(currencyProvider);
    final documentNumber = await ref
        .read(documentsProvider.notifier)
        ._generateDocumentNumber(DocumentType.invoice);

    final document = Document(
      type: DocumentType.invoice,
      documentNumber: documentNumber,
      title: _titleController.text,
      totalAmount: _total,
      currency: currency,
      data: {
        'businessId': _selectedBusiness?.id,
        'customerId': _selectedCustomer?.id,
        'customerName': _selectedCustomer?.name,
        'invoiceDate': _invoiceDate.toIso8601String(),
        'dueDate': _dueDate.toIso8601String(),
        'items': _items.map((item) => item.toMap()).toList(),
        'taxPercent': _taxPercent,
        'discountPercent': _discountPercent,
        'subtotal': _subtotal,
        'taxAmount': _taxAmount,
        'discountAmount': _discountAmount,
        'notes': _notesController.text,
      },
    );

    await ref.read(documentsProvider.notifier).addDocument(document);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _previewPDF() async {
    // TODO: Implement PDF preview
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF preview coming soon')),
    );
  }
}
