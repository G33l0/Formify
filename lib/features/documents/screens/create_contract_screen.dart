import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/document.dart';
import '../../../providers/document_provider.dart';
import '../../widgets/custom_text_field.dart';

class CreateContractScreen extends ConsumerStatefulWidget {
  final DocumentType type;

  const CreateContractScreen({
    super.key,
    this.type = DocumentType.contract,
  });

  @override
  ConsumerState<CreateContractScreen> createState() =>
      _CreateContractScreenState();
}

class _CreateContractScreenState extends ConsumerState<CreateContractScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _party1Controller = TextEditingController();
  final _party2Controller = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.type.name;
    _loadTemplate();
  }

  void _loadTemplate() {
    switch (widget.type) {
      case DocumentType.contract:
        _contentController.text = _getContractTemplate();
        break;
      case DocumentType.coverLetter:
        _contentController.text = _getCoverLetterTemplate();
        break;
      case DocumentType.rentalAgreement:
        _contentController.text = _getRentalTemplate();
        break;
      case DocumentType.letter:
        _contentController.text = _getLetterTemplate();
        break;
      default:
        _contentController.text = '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _party1Controller.dispose();
    _party2Controller.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create ${widget.type.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _saveDocument,
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
              label: 'Title',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            if (widget.type != DocumentType.coverLetter) ...[
              CustomTextField(
                controller: _party1Controller,
                label: 'First Party Name',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _party2Controller,
                label: 'Second Party Name',
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              controller: _contentController,
              label: 'Content',
              maxLines: 20,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveDocument,
              icon: const Icon(Icons.save_rounded),
              label: Text('Save ${widget.type.name}'),
            ),
          ],
        ),
      ),
    );
  }

  String _getContractTemplate() {
    return '''This Agreement is entered into on [DATE] between:

Party 1: [PARTY_1_NAME]
Party 2: [PARTY_2_NAME]

Terms and Conditions:

1. Scope of Work
[Describe the work or services to be provided]

2. Payment Terms
[Describe payment amount and schedule]

3. Duration
This agreement shall commence on [START_DATE] and continue until [END_DATE].

4. Termination
Either party may terminate this agreement with [NOTICE_PERIOD] days written notice.

5. Confidentiality
Both parties agree to maintain confidentiality of proprietary information.

Signatures:

Party 1: ___________________ Date: ___________

Party 2: ___________________ Date: ___________''';
  }

  String _getCoverLetterTemplate() {
    return '''[Your Name]
[Your Address]
[City, State ZIP]
[Your Email]
[Your Phone]

[Date]

[Hiring Manager's Name]
[Company Name]
[Company Address]
[City, State ZIP]

Dear [Hiring Manager's Name],

I am writing to express my strong interest in the [Position Name] position at [Company Name]. With my background in [Your Field/Industry] and [X] years of experience, I am confident in my ability to contribute to your team.

[Paragraph highlighting your relevant experience and skills]

[Paragraph explaining why you're interested in this company and role]

[Closing paragraph expressing enthusiasm and requesting an interview]

Thank you for considering my application. I look forward to discussing how my skills and experience align with your needs.

Sincerely,
[Your Name]''';
  }

  String _getRentalTemplate() {
    return '''RENTAL AGREEMENT

This Rental Agreement is made on [DATE] between:

Landlord: [PARTY_1_NAME]
Tenant: [PARTY_2_NAME]

Property Address: [PROPERTY_ADDRESS]

Terms:

1. Rental Period: From [START_DATE] to [END_DATE]

2. Rent: [AMOUNT] per month, due on the [DAY] of each month

3. Security Deposit: [DEPOSIT_AMOUNT]

4. Utilities: [Specify which utilities are included]

5. Maintenance: [Describe maintenance responsibilities]

6. Termination: [Notice period and conditions]

Landlord Signature: ___________________ Date: ___________

Tenant Signature: ___________________ Date: ___________''';
  }

  String _getLetterTemplate() {
    return '''[Your Name]
[Your Address]
[City, State ZIP]
[Date]

[Recipient Name]
[Recipient Address]
[City, State ZIP]

Dear [Recipient Name],

[Write your letter content here]

Sincerely,
[Your Name]''';
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) return;

    final documentNumber = await ref
        .read(documentsProvider.notifier)
        ._generateDocumentNumber(widget.type);

    // Replace placeholders with actual values
    String processedContent = _contentController.text;
    processedContent = processedContent.replaceAll(
      '[PARTY_1_NAME]',
      _party1Controller.text,
    );
    processedContent = processedContent.replaceAll(
      '[PARTY_2_NAME]',
      _party2Controller.text,
    );
    processedContent = processedContent.replaceAll(
      '[DATE]',
      DateTime.now().toString().split(' ')[0],
    );

    final document = Document(
      type: widget.type,
      documentNumber: documentNumber,
      title: _titleController.text,
      data: {
        'party1': _party1Controller.text,
        'party2': _party2Controller.text,
        'content': processedContent,
      },
    );

    await ref.read(documentsProvider.notifier).addDocument(document);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.type.name} saved successfully')),
      );
      Navigator.pop(context);
    }
  }
}
