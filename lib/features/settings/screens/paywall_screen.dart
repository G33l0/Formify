import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/premium_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedPlan = 'monthly';
  bool _isLoading = false;

  final List<String> _features = [
    'Remove watermark from PDFs',
    'Unlimited document saves',
    'Upload custom logo',
    'Premium templates',
    'Multiple business profiles',
    'Cloud backup & sync',
    'Priority support',
    'Ad-free experience',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.accentColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Formify Premium',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Unlock all features and create unlimited professional documents',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Features list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Premium Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._features.map((feature) => _buildFeatureItem(feature)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pricing plans
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildPlanCard(
                    'Monthly',
                    '\$4.99',
                    'per month',
                    'monthly',
                  ),
                  const SizedBox(height: 12),
                  _buildPlanCard(
                    'Yearly',
                    '\$39.99',
                    'per year',
                    'yearly',
                    discount: 'Save 33%',
                    recommended: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Purchase button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handlePurchase,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _selectedPlan == 'monthly'
                                  ? 'Subscribe for \$4.99/month'
                                  : 'Subscribe for \$39.99/year',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _handleRestore,
                    child: const Text('Restore Purchase'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Cancel anytime. Auto-renewable subscription.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.successColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    String title,
    String price,
    String period,
    String planId, {
    String? discount,
    bool recommended = false,
  }) {
    final isSelected = _selectedPlan == planId;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPlan = planId;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: planId,
                  groupValue: _selectedPlan,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlan = value!;
                    });
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (discount != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                discount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            period,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (recommended)
              Positioned(
                top: -8,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'RECOMMENDED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate purchase flow
    // In production, integrate with in_app_purchase package
    await Future.delayed(const Duration(seconds: 2));

    // For demo purposes, activate premium
    await ref.read(isPremiumProvider.notifier).setPremium(true);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Premium activated! Thank you for your support.'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _handleRestore() async {
    await ref.read(isPremiumProvider.notifier).restorePurchase();

    if (mounted) {
      final isPremium = ref.read(isPremiumProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isPremium
                ? 'Purchase restored successfully'
                : 'No previous purchase found',
          ),
        ),
      );

      if (isPremium) {
        Navigator.pop(context);
      }
    }
  }
}
