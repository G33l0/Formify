import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/document.dart';
import '../../../models/resume_models.dart';
import '../../../providers/document_provider.dart';
import '../../widgets/custom_text_field.dart';

class CreateResumeScreen extends ConsumerStatefulWidget {
  const CreateResumeScreen({super.key});

  @override
  ConsumerState<CreateResumeScreen> createState() =>
      _CreateResumeScreenState();
}

class _CreateResumeScreenState extends ConsumerState<CreateResumeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Info
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _summaryController = TextEditingController();

  List<Experience> _experiences = [];
  List<Education> _educations = [];
  List<Skill> _skills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Resume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _saveResume,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _fullNameController,
              label: 'Full Name',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _phoneController,
              label: 'Phone',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _addressController,
              label: 'Address',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _summaryController,
              label: 'Professional Summary',
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Experience Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Experience',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addExperience,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            ..._experiences.asMap().entries.map((entry) {
              return _buildExperienceCard(entry.key, entry.value);
            }),

            const SizedBox(height: 24),

            // Education Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Education',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addEducation,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            ..._educations.asMap().entries.map((entry) {
              return _buildEducationCard(entry.key, entry.value);
            }),

            const SizedBox(height: 24),

            // Skills Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Skills',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addSkill,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            ..._skills.asMap().entries.map((entry) {
              return _buildSkillCard(entry.key, entry.value);
            }),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _saveResume,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Resume'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(int index, Experience exp) {
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
                    'Experience ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () {
                    setState(() {
                      _experiences.removeAt(index);
                    });
                  },
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: exp.position,
              decoration: const InputDecoration(
                labelText: 'Position',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _experiences[index] = Experience(
                  position: value,
                  company: exp.company,
                  startDate: exp.startDate,
                  endDate: exp.endDate,
                  description: exp.description,
                );
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: exp.company,
              decoration: const InputDecoration(
                labelText: 'Company',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _experiences[index] = Experience(
                  position: exp.position,
                  company: value,
                  startDate: exp.startDate,
                  endDate: exp.endDate,
                  description: exp.description,
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: exp.startDate,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _experiences[index] = Experience(
                        position: exp.position,
                        company: exp.company,
                        startDate: value,
                        endDate: exp.endDate,
                        description: exp.description,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: exp.endDate,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _experiences[index] = Experience(
                        position: exp.position,
                        company: exp.company,
                        startDate: exp.startDate,
                        endDate: value,
                        description: exp.description,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: exp.description,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                _experiences[index] = Experience(
                  position: exp.position,
                  company: exp.company,
                  startDate: exp.startDate,
                  endDate: exp.endDate,
                  description: value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard(int index, Education edu) {
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
                    'Education ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () {
                    setState(() {
                      _educations.removeAt(index);
                    });
                  },
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: edu.degree,
              decoration: const InputDecoration(
                labelText: 'Degree',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _educations[index] = Education(
                  degree: value,
                  institution: edu.institution,
                  startDate: edu.startDate,
                  endDate: edu.endDate,
                );
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: edu.institution,
              decoration: const InputDecoration(
                labelText: 'Institution',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _educations[index] = Education(
                  degree: edu.degree,
                  institution: value,
                  startDate: edu.startDate,
                  endDate: edu.endDate,
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: edu.startDate,
                    decoration: const InputDecoration(
                      labelText: 'Start Year',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _educations[index] = Education(
                        degree: edu.degree,
                        institution: edu.institution,
                        startDate: value,
                        endDate: edu.endDate,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: edu.endDate,
                    decoration: const InputDecoration(
                      labelText: 'End Year',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _educations[index] = Education(
                        degree: edu.degree,
                        institution: edu.institution,
                        startDate: edu.startDate,
                        endDate: value,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(int index, Skill skill) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: TextFormField(
          initialValue: skill.name,
          decoration: const InputDecoration(
            labelText: 'Skill Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _skills[index] = Skill(name: value, level: skill.level);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () {
            setState(() {
              _skills.removeAt(index);
            });
          },
          color: Colors.red,
        ),
      ),
    );
  }

  void _addExperience() {
    setState(() {
      _experiences.add(Experience(
        position: '',
        company: '',
        startDate: '',
        endDate: 'Present',
      ));
    });
  }

  void _addEducation() {
    setState(() {
      _educations.add(Education(
        degree: '',
        institution: '',
        startDate: '',
        endDate: '',
      ));
    });
  }

  void _addSkill() {
    setState(() {
      _skills.add(Skill(name: ''));
    });
  }

  Future<void> _saveResume() async {
    if (!_formKey.currentState!.validate()) return;

    final documentNumber = await ref
        .read(documentsProvider.notifier)
        ._generateDocumentNumber(DocumentType.resume);

    final document = Document(
      type: DocumentType.resume,
      documentNumber: documentNumber,
      title: '${_fullNameController.text} - Resume',
      data: {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'summary': _summaryController.text,
        'experiences': _experiences.map((e) => e.toMap()).toList(),
        'educations': _educations.map((e) => e.toMap()).toList(),
        'skills': _skills.map((s) => s.toMap()).toList(),
      },
    );

    await ref.read(documentsProvider.notifier).addDocument(document);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume saved successfully')),
      );
      Navigator.pop(context);
    }
  }
}
