import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:my_app/widgets/bottom_nav.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/services/transaction_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TransactionService _transactionService = TransactionService();
  
  final List<Map<String, dynamic>> _categoryDefinitions = [
    {"nameKey": "cat_food", "color": const Color(0xFFFF9800), "icon": Icons.restaurant},
    {"nameKey": "cat_transport", "color": const Color(0xFF2196F3), "icon": Icons.directions_car},
    {"nameKey": "cat_entertainment", "color": const Color(0xFF9C27B0), "icon": Icons.movie},
    {"nameKey": "cat_shopping", "color": const Color(0xFFFFC107), "icon": Icons.shopping_bag},
    {"nameKey": "cat_health", "color": const Color(0xFFF44336), "icon": Icons.local_hospital},
    {"nameKey": "cat_education", "color": const Color(0xFF4CAF50), "icon": Icons.school},
    {"nameKey": "cat_other", "color": const Color(0xFF9E9E9E), "icon": Icons.more_horiz},
  ];

  final List<String> monthsKeys = [
    'month_01',
    'month_02',
    'month_03',
    'month_04',
    'month_05',
    'month_06',
    'month_07',
    'month_08',
    'month_09',
    'month_10',
    'month_11',
    'month_12',
  ];

  int selectedMonthIndex = DateTime.now().month - 1;
  String selectedYear = DateTime.now().year.toString();
  int income = 8000000; // sample income

  @override
  void initState() {
    super.initState();
    _transactionService.addListener(_updateData);
  }

  @override
  void dispose() {
    _transactionService.removeListener(_updateData);
    super.dispose();
  }

  void _updateData() {
    if (mounted) {
      setState(() {});
    }
  }

  String formatCurrency(int value) {
    return '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';
  }

  List<Map<String, dynamic>> get categories {
    final transactions = _transactionService.transactions;
    final Map<String, int> categoryTotals = {};
    
    // Tính tổng theo category từ transactions
    for (var trans in transactions) {
      if (trans['type'] == 'expense') {
        final catKey = trans['categoryKey'] ?? trans['category'] ?? 'cat_other';
        categoryTotals[catKey] = (categoryTotals[catKey] ?? 0) + (trans['amount'] as int);
      }
    }
    
    // Tạo list categories với giá trị thực tế
    return _categoryDefinitions.map((catDef) {
      final value = categoryTotals[catDef['nameKey']] ?? 0;
      return {
        'nameKey': catDef['nameKey'],
        'value': value,
        'color': catDef['color'],
        'icon': catDef['icon'],
      };
    }).where((cat) => cat['value'] > 0).toList()
      ..sort((a, b) => (b['value'] as int).compareTo(a['value'] as int));
  }

  int get totalExpense => categories.fold(0, (s, e) => s + (e['value'] as int));
  
  int get totalIncome {
    return _transactionService.getTotalAmountByType('income');
  }

  @override
  Widget build(BuildContext context) {
    final expense = totalExpense;
    final incomeAmount = totalIncome > 0 ? totalIncome : income;
    final balance = incomeAmount - expense;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildMonthSelector(),
          _buildQuickStats(expense, balance, incomeAmount),
          if (categories.isNotEmpty) _buildChartSection(expense),
          _buildDetailedList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'report_title'.tr(),
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
                AppColors.primary.withOpacity(0.8),
                AppColors.primary.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 70, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, 
                            color: Colors.white70, 
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'report_month'.tr(),
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${tr(monthsKeys[selectedMonthIndex])} • $selectedYear',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, 
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {},
                      tooltip: 'share'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: List.generate(monthsKeys.length, (i) {
                    final bool sel = i == selectedMonthIndex;
                    return GestureDetector(
                      onTap: () => setState(() => selectedMonthIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: sel
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          tr(monthsKeys[i]),
                          style: GoogleFonts.poppins(
                            color: sel ? Colors.white : Colors.grey[700],
                            fontSize: 13,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildYearPicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildYearPicker() {
    return PopupMenuButton<String>(
      initialValue: selectedYear,
      onSelected: (v) => setState(() => selectedYear = v),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (_) => ['2023', '2024', '2025', '2026']
          .map((y) => PopupMenuItem(
                value: y,
                child: Text(
                  y,
                  style: GoogleFonts.poppins(),
                ),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
              Icons.arrow_drop_down_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(int expense, int balance, int incomeAmount) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _quickStatCard(
                    'income'.tr(),
                    formatCurrency(incomeAmount),
                    Icons.trending_up_rounded,
                    Colors.green,
                    const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickStatCard(
                    'expense'.tr(),
                    formatCurrency(expense),
                    Icons.trending_down_rounded,
                    Colors.redAccent,
                    const Color(0xFFEF5350),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _quickStatCard(
              'balance'.tr(),
              formatCurrency(balance),
              Icons.account_balance_wallet_rounded,
              AppColors.primary,
              AppColors.primary,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color gradientColor, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColor,
            gradientColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(int expense) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.pie_chart_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'category_breakdown'.tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildDonutChart(expense),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: _buildLegend(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChart(int expense) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _PiePainter(
              categories.map((e) => (e['value'] as int).toDouble()).toList(),
              categories.map((e) => e['color'] as Color).toList(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatCurrency(expense),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'total_expense'.tr(),
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.asMap().entries.map((entry) {
        final c = entry.value;
        final int v = c['value'] as int;
        final pct = totalExpense == 0 ? 0.0 : (v / totalExpense);
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (c['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  c['icon'] as IconData,
                  color: c['color'] as Color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (c['nameKey'] as String).tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatCurrency(v),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (c['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(pct * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: c['color'] as Color,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailedList() {
    if (categories.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
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
            children: [
              Icon(
                Icons.bar_chart_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'no_data'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'add_transaction_to_see_report'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((ctx, i) {
          final c = categories[i];
          final v = c['value'] as int;
          final pct = totalExpense == 0 ? 0.0 : (v / totalExpense);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (c['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          c['icon'] as IconData,
                          color: c['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (c['nameKey'] as String).tr(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatCurrency(v),
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  c['color'] as Color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: (c['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(pct * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: c['color'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }, childCount: categories.length),
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _PiePainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.isEmpty ? 0.0 : values.reduce((a, b) => a + b);
    if (total <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final stroke = radius * 0.4;
    double startRadian = -pi / 2;

    final rect = Rect.fromCircle(center: center, radius: radius - stroke / 2);

    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = colors[i];
      canvas.drawArc(rect, startRadian, sweep, false, paint);
      startRadian += sweep;
    }

    // Vẽ vòng tròn trắng bên trong
    canvas.drawCircle(
      center,
      radius - stroke - 6,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_PiePainter old) =>
      old.values != values || old.colors != colors;
}
