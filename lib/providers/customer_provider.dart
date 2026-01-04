import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';
import '../core/database/database_helper.dart';

// Customers provider
final customersProvider = StateNotifierProvider<CustomersNotifier, List<Customer>>((ref) {
  return CustomersNotifier();
});

class CustomersNotifier extends StateNotifier<List<Customer>> {
  CustomersNotifier() : super([]) {
    loadCustomers();
  }

  final _db = DatabaseHelper.instance;

  Future<void> loadCustomers() async {
    final maps = await _db.queryAll('customers');
    state = maps.map((map) => Customer.fromMap(map)).toList();
  }

  Future<void> addCustomer(Customer customer) async {
    await _db.insert('customers', customer.toMap());
    await loadCustomers();
  }

  Future<void> updateCustomer(Customer customer) async {
    await _db.update('customers', customer.toMap());
    await loadCustomers();
  }

  Future<void> deleteCustomer(String id) async {
    await _db.delete('customers', id);
    await loadCustomers();
  }

  List<Customer> searchCustomers(String query) {
    if (query.isEmpty) return state;

    final lowerQuery = query.toLowerCase();
    return state.where((customer) {
      return customer.name.toLowerCase().contains(lowerQuery) ||
          (customer.email?.toLowerCase().contains(lowerQuery) ?? false) ||
          (customer.phone?.contains(query) ?? false);
    }).toList();
  }
}
