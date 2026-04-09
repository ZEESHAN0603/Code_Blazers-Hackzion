import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/expense_tile.dart';
import '../widgets/glass_card.dart';
import '../models/transaction_model.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MockDataService>(context);
    final filteredTransactions = data.transactions
        .where((t) => t.merchant.toLowerCase().contains(_filterQuery.toLowerCase()))
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  return ExpenseTile(transaction: filteredTransactions[index]);
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Expenses',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Icon(Icons.filter_list_rounded, color: Colors.white),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _filterQuery = value),
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton('Add', Icons.add, () => _showAddExpenseDialog(context)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildButton('Receipt', Icons.receipt_long, () => _showSnackbar(context, 'Receipt Uploading...')),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildButton('PDF', Icons.picture_as_pdf, () => _showSnackbar(context, 'Scanning Bank PDF...')),
        ),
      ],
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final merchantController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'Food';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: merchantController, decoration: const InputDecoration(labelText: 'Merchant Name')),
            TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: category,
              items: ['Food', 'Transport', 'Shopping', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => category = val!,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (merchantController.text.isNotEmpty && amountController.text.isNotEmpty) {
                Provider.of<MockDataService>(context, listen: false).addTransaction(
                  Transaction(
                    id: DateTime.now().toString(),
                    merchant: merchantController.text,
                    amount: double.parse(amountController.text),
                    category: category,
                    date: DateTime.now(),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
