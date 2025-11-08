import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:my_app/widgets/bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int budget = 5000000;
  int spent = 2500000;

  // lưu các giao dịch được thêm (trả về từ màn Add)
  final List<Map<String, dynamic>> _transactions = [];

  int selectedMonthIndex = 9; // Tháng 10
  String selectedYear = '2025';

  // categories lưu bằng key để dễ localized bằng tr(key)
  final List<Map<String, dynamic>> categories = [
    {
      "key": "cat_food",
      "value": 800000,
      "color": const Color(0xFFFF9800),
      "icon": Icons.restaurant,
    },
    {
      "key": "cat_transport",
      "value": 400000,
      "color": const Color(0xFF2196F3),
      "icon": Icons.directions_car,
    },
    {
      "key": "cat_entertainment",
      "value": 300000,
      "color": const Color(0xFF9C27B0),
      "icon": Icons.sports_esports,
    },
    {
      "key": "cat_shopping",
      "value": 600000,
      "color": const Color(0xFFFFC107),
      "icon": Icons.shopping_bag,
    },
    {
      "key": "cat_other",
      "value": 400000,
      "color": const Color(0xFF607D8B),
      "icon": Icons.more_horiz,
    },
  ];

  String formatCurrency(int value) {
    return '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';
  }

  // cập nhật categories và spent từ _transactions
  void _updateCategories() {
    // reset giá trị
    for (var cat in categories) {
      cat['value'] = 0;
    }

    // tổng lại từ transactions (support cả 'categoryKey' hoặc legacy 'category')
    for (var trans in _transactions) {
      if (trans['type'] == 'expense') {
        final String catKey =
            trans['categoryKey'] ?? trans['category'] ?? 'cat_other';
        final category = categories.firstWhere(
          (c) => c['key'] == catKey,
          orElse: () => categories.last,
        );
        category['value'] =
            (category['value'] as int) + (trans['amount'] as int);
      }
    }

    // tính lại tổng spent
    spent = _transactions
        .where((t) => t['type'] == 'expense')
        .fold(0, (sum, t) => sum + (t['amount'] as int));
  }

  List<String> get _monthLabels => List.generate(12, (i) {
        final idx = (i + 1).toString().padLeft(2, '0');
        return tr('month_$idx');
      });

  @override
  Widget build(BuildContext context) {
    final int remaining = (budget - spent).clamp(0, budget);
    final double spentPercent = budget == 0 ? 0 : spent / budget;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar với gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                tr('home_title'),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('total_budget'),
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCurrency(budget),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bộ lọc tháng/năm
                  _buildMonthYearFilter(),
                  const SizedBox(height: 20),

                  // Thẻ thống kê
                  _buildStatisticsCards(remaining, spentPercent),
                  const SizedBox(height: 20),

                  // Progress bar
                  _buildProgressBar(spentPercent),
                  const SizedBox(height: 24),

                  // Tiêu đề danh mục
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr('category_details'),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(tr('see_all')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Danh sách category
                  ...categories.map((c) => _buildCategoryCard(c)),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // FAB: dấu cộng, màu tương phản với thanh điều hướng và nền
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Đợi kết quả trả về từ AddTransactionScreen
          final result = await Navigator.pushNamed(context, '/add');

          // Nếu có dữ liệu trả về (user đã save)
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _transactions.add(result);
              _updateCategories();
            });

            // Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${tr('transaction_added')}: ${result['name']}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _buildMonthYearFilter() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Chọn năm
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: PopupMenuButton<String>(
              initialValue: selectedYear,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedYear,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
              onSelected: (value) {
                setState(() {
                  selectedYear = value;
                });
              },
              itemBuilder: (context) => ['2023', '2024', '2025', '2026']
                  .map((year) => PopupMenuItem(value: year, child: Text(year)))
                  .toList(),
            ),
          ),
          const SizedBox(width: 8),
          // Chọn tháng
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _monthLabels.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                bool isSelected = index == selectedMonthIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMonthIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _monthLabels[index],
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(int remaining, double spentPercent) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            tr('remaining'),
            formatCurrency(remaining),
            Icons.account_balance_wallet,
            const Color(0xFF4CAF50),
            '${((1 - spentPercent) * 100).toStringAsFixed(0)}%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            tr('total_expense'),
            formatCurrency(spent),
            Icons.shopping_cart,
            const Color(0xFFEF5350),
            '${(spentPercent * 100).toStringAsFixed(0)}%',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String percent,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double percent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr('progress', namedArgs: {
                  'percent': ((percent * 100)).toStringAsFixed(1)
                }),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '${(percent * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: percent > 0.8 ? Colors.red : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                percent > 0.8 ? Colors.red : AppColors.primary,
              ),
            ),
          ),
          if (percent > 0.8) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange[700],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    tr('feature_in_development'), // reuse a message or add a new key if preferred
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    double percent =
        spent == 0 ? 0 : (category['value'] as int) / (spent == 0 ? 1 : spent);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (category['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(category['key'] as String),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatCurrency(category['value'] as int),
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 4,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      category['color'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Percentage
          Text(
            '${(percent * 100).toStringAsFixed(0)}%',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: category['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }
}
