import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/document.dart';
import '../../../models/invoice_item.dart';
import '../../../providers/document_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/custom_text_field.dart';

class CreateReceiptScreen extends ConsumerStatefulWidget {
  const CreateReceiptScreen({super.key});

  @override
  ConsumerState<CreateReceiptScreen> createState() =>
      _CreateReceiptScreenState();
}

class _CreateReceiptScreenState extends ConsumerState<CreateReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _receiptDate = DateTime.now();
  List<InvoiceItem> _items = [];
  double _taxPercent = 0.0;
  String _paymentMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    _titleController.text = 'Receipt';
    _items.add(InvoiceItem(description: '', quantity: 1, rate: 0.0));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customerNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get _taxAmount {
    return _subtotal * (_taxPercent / 100);
  }

  double get _total {
    return _subtotal + _taxAmount;
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _saveReceipt,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              controller: _titleController,
              label: 'Receipt Title',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _customerNameController,
              label: 'Customer Name',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Date
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _receiptDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _receiptDate = picked);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Receipt Date',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(_receiptDate)),
                    const Icon(Icons.calendar_today_rounded, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: ['Cash', 'Card', 'Bank Transfer', 'Check', 'Other']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _paymentMethod = value!);
              },
            ),
            const SizedBox(height: 24),

            // Items
            const Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ..._buildItemsList(),

            TextButton.icon(
              onPressed: () {
                setState(() {
                  _items.add(InvoiceItem(description: '', quantity: 1, rate: 0.0));
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),

            const SizedBox(height: 16),

            // Tax
            TextFormField(
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

            const SizedBox(height: 24),

            // Totals
            Card(
              elevation: 4,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTotalRow('Subtotal', _subtotal, currency),
                    if (_taxPercent > 0) ...[
                      const SizedBox(height: 8),
                      _buildTotalRow('Tax ($_taxPercent%)', _taxAmount, currency),
                    ],
                    const Divider(height: 24),
                    _buildTotalRow('Total Paid', _total, currency, isTotal: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: _notesController,
              label: 'Notes (optional)',
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _saveReceipt,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Receipt'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemsList() {
    return List.generate(_items.length, (index) {
      final item = _items[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
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
                  if (_items.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () {
                        setState(() {
                          _items.removeAt(index);
                        });
                      },
                      color: Colors.red,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTotalRow(String label, double amount, String currency,
      {bool isTotal = false}) {
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

  Future<void> _saveReceipt() async {
    if (!_formKey.currentState!.validate()) return;

    final currency = ref.read(currencyProvider);
    final documentNumber = await ref
        .read(documentsProvider.notifier)
        ._generateDocumentNumber(DocumentType.receipt);

    final document = Document(
      type: DocumentType.receipt,
      documentNumber: documentNumber,
      title: _titleController.text,
      totalAmount: _total,
      currency: currency,
      data: {
        'customerName': _customerNameController.text,
        'receiptDate': _receiptDate.toIso8601String(),
        'paymentMethod': _paymentMethod,
        'items': _items.map((item) => item.toMap()).toList(),
        'taxPercent': _taxPercent,
        'subtotal': _subtotal,
        'taxAmount': _taxAmount,
        'notes': _notesController.text,
      },
    );

    await ref.read(documentsProvider.notifier).addDocument(document);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt saved successfully')),
      );
      Navigator.pop(context);
    }
  }
}
