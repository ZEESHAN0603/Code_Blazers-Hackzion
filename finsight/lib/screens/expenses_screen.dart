import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../widgets/expense_tile.dart';
import '../core/constants.dart';
import '../models/transaction_model.dart';
import 'package:file_picker/file_picker.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MockDataService>(context);

    return Scaffold(
      backgroundColor: AppColors.slateBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomHeader(),
            const SizedBox(height: 20),
            _buildQuickCapture(context, data),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle('Recent Transactions'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.transactions.length,
                itemBuilder: (context, index) {
                  return ExpenseTile(transaction: data.transactions[index], index: index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showManualEntrySheet(context, data),
        backgroundColor: AppColors.accentBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Manually', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Transaction Analysis', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const Text('Track Expenses', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navyDark)),
        ],
      ),
    );
  }

  Widget _buildQuickCapture(BuildContext context, MockDataService data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _captureCard(
              context,
              title: 'OCR Scan',
              subtitle: 'Scan Receipt',
              icon: Icons.receipt_long_rounded,
              color: AppColors.accentBlue,
              onTap: () => _pickAndSimulateOCR(context, data),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _captureCard(
              context,
              title: 'PDF Import',
              subtitle: 'Bank Statement',
              icon: Icons.picture_as_pdf_outlined,
              color: AppColors.accentGreen,
              onTap: () => _pickAndSimulatePDF(context, data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _captureCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppStyles.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navyDark)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navyDark));
  }

  void _showManualEntrySheet(BuildContext context, MockDataService data) {
    final merchant = TextEditingController();
    final amount = TextEditingController();
    final note = TextEditingController();
    String category = 'Food';
    String paymentMethod = 'UPI';
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 24, right: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              const Text('Add New Expense', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.navyDark)),
              const SizedBox(height: 24),
              TextField(
                controller: merchant,
                decoration: InputDecoration(
                  labelText: 'Where did you spend?',
                  prefixIcon: const Icon(Icons.storefront_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixIcon: const Icon(Icons.currency_rupee_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: category,
                      decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                      items: ['Food', 'Transport', 'Shopping', 'Bills', 'Entertainment'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => category = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: paymentMethod,
                      decoration: InputDecoration(labelText: 'Method', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                      items: ['UPI', 'Credit Card', 'Cash', 'Wallet'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (v) => setState(() => paymentMethod = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: note,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: const Icon(Icons.notes_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (merchant.text.isNotEmpty && amount.text.isNotEmpty) {
                      data.addTransaction(Transaction(
                        id: DateTime.now().toString(),
                        merchant: merchant.text,
                        amount: double.parse(amount.text),
                        category: category,
                        date: selectedDate,
                        paymentMethod: paymentMethod,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navyDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text('Save Expense', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndSimulateOCR(BuildContext context, MockDataService data) async {
    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null) {
      _simulateOCR(context, data);
    }
  }

  Future<void> _pickAndSimulatePDF(BuildContext context, MockDataService data) async {
    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      _simulatePDF(context, data);
    }
  }

  Future<void> _simulateOCR(BuildContext context, MockDataService data) async {
    _showLoadingDialog(context, 'Scanning Receipt...');
    final result = await data.simulateOCR();
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt Found'),
        content: Text('Merchant: ${result.merchant}\nAmount: ₹${result.amount}\nCategory: ${result.category}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Discard')),
          ElevatedButton(
            onPressed: () {
              data.addTransaction(result);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _simulatePDF(BuildContext context, MockDataService data) async {
    _showLoadingDialog(context, 'Parsing Bank Statement...');
    final results = await data.simulatePDF();
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statement Summary'),
        content: Text('Detected ${results.length} transactions totaling ₹${results.fold(0.0, (sum, item) => sum + item.amount).toStringAsFixed(0)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              for (var tx in results) { data.addTransaction(tx); }
              Navigator.pop(context);
            },
            child: const Text('Import All'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(color: AppColors.accentBlue),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
