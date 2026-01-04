import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/document.dart';
import '../../../providers/document_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text_field.dart';

class CreateQuoteScreen extends ConsumerStatefulWidget {
  const CreateQuoteScreen({super.key});

  @override
  ConsumerState<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends ConsumerState<CreateQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Quotation');
  final _customerNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _validityController = TextEditingController(text: '30');

  @override
  void dispose() {
    _titleController.dispose();
    _customerNameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _validityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quotation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _saveQuote,
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
              label: 'Quote Title',
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
            CustomTextField(
              controller: _descriptionController,
              label: 'Description of Work',
              maxLines: 5,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _amountController,
              label: 'Quoted Amount',
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _validityController,
              label: 'Valid for (days)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveQuote,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Quotation'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveQuote() async {
    if (!_formKey.currentState!.validate()) return;

    final currency = ref.read(currencyProvider);
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final documentNumber = await ref
        .read(documentsProvider.notifier)
        ._generateDocumentNumber(DocumentType.quotation);

    final document = Document(
      type: DocumentType.quotation,
      documentNumber: documentNumber,
      title: _titleController.text,
      totalAmount: amount,
      currency: currency,
      data: {
        'customerName': _customerNameController.text,
        'description': _descriptionController.text,
        'validityDays': int.tryParse(_validityController.text) ?? 30,
        'quotedAmount': amount,
      },
    );

    await ref.read(documentsProvider.notifier).addDocument(document);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quotation saved successfully')),
      );
      Navigator.pop(context);
    }
  }
}
