import 'package:flutter/material.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:my_app/services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  // store type as key
  String _selectedType = 'expense'; // 'expense' or 'income'
  // store category by key so it can be localized
  String _selectedCategoryKey = 'cat_food';
  DateTime _selectedDate = DateTime.now();
  
  final TransactionService _transactionService = TransactionService();

  final List<Map<String, dynamic>> _categories = [
    {'key': 'cat_food', 'icon': Icons.restaurant, 'color': Color(0xFFFF9800)},
    {
      'key': 'cat_transport',
      'icon': Icons.directions_car,
      'color': Color(0xFF2196F3)
    },
    {
      'key': 'cat_entertainment',
      'icon': Icons.movie,
      'color': Color(0xFF9C27B0)
    },
    {
      'key': 'cat_shopping',
      'icon': Icons.shopping_bag,
      'color': Color(0xFFFFC107)
    },
    {
      'key': 'cat_health',
      'icon': Icons.local_hospital,
      'color': Color(0xFFF44336)
    },
    {'key': 'cat_education', 'icon': Icons.school, 'color': Color(0xFF4CAF50)},
    {'key': 'cat_other', 'icon': Icons.more_horiz, 'color': Color(0xFF9E9E9E)},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final selectedCategory =
          _categories.firstWhere((c) => c['key'] == _selectedCategoryKey);
      final transaction = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text.trim(),
        'amount': int.parse(_amountController.text),
        'type': _selectedType,
        'categoryKey': _selectedCategoryKey,
        'categoryName': tr(_selectedCategoryKey),
        'date': _selectedDate,
        'icon': selectedCategory['icon'],
        'color': selectedCategory['color'],
      };

      // Lưu vào TransactionService
      _transactionService.addTransaction(transaction);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${'transaction_added'.tr()}: ${transaction['name']}'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Quay về màn hình trước
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('add_transaction'.tr(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTypeSelector(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildAmountField(),
                    const SizedBox(height: 16),
                    _buildCategorySelector(),
                    const SizedBox(height: 16),
                    _buildDatePicker(),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              'expense'.tr(),
              'expense',
              Icons.arrow_downward,
              Colors.redAccent,
            ),
          ),
          Expanded(
            child: _buildTypeButton(
              'income'.tr(),
              'income',
              Icons.arrow_upward,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(
      String label, String value, IconData icon, Color color) {
    final isSelected = _selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'transaction_name'.tr(),
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => (value?.isEmpty ?? true) ? 'enter_name'.tr() : null,
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'amount'.tr(),
        prefixIcon: const Icon(Icons.attach_money),
        suffixText: 'đ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'enter_amount'.tr();
        if (int.tryParse(value!) == null) return 'invalid_amount'.tr();
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('category'.tr(),
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                _categories.map((cat) => _buildCategoryChip(cat)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(Map<String, dynamic> category) {
    final isSelected = _selectedCategoryKey == category['key'];
    return GestureDetector(
      onTap: () =>
          setState(() => _selectedCategoryKey = category['key'] as String),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (category['color'] as Color).withOpacity(0.2)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? (category['color'] as Color) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category['icon'] as IconData,
                size: 18,
                color: isSelected ? category['color'] as Color : Colors.grey),
            const SizedBox(width: 6),
            Text(
              tr(category['key'] as String),
              style: GoogleFonts.poppins(
                color:
                    isSelected ? category['color'] as Color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
                '${'date'.tr()}: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                style: GoogleFonts.poppins(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      onPressed: _saveTransaction,
      child: Text('save_transaction'.tr(),
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }
}
