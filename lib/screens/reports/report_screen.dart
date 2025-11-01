import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:my_app/widgets/bottom_nav.dart';
import 'package:easy_localization/easy_localization.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Ăn uống", "value": 1200000, "color": const Color(0xFFFF9800)},
    {"name": "Đi lại", "value": 800000, "color": const Color(0xFF2196F3)},
    {"name": "Giải trí", "value": 600000, "color": const Color(0xFF9C27B0)},
    {"name": "Mua sắm", "value": 1400000, "color": const Color(0xFFFFC107)},
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

  String formatCurrency(int value) {
    return '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';
  }

  int get totalExpense => categories.fold(0, (s, e) => s + (e['value'] as int));

  @override
  Widget build(BuildContext context) {
    final expense = totalExpense;
    final balance = income - expense;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildMonthSelector(),
          _buildQuickStats(expense, balance),
          _buildChartSection(expense),
          _buildDetailedList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('report_title'.tr(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.75),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('report_month'.tr(),
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        '${tr(monthsKeys[selectedMonthIndex])} • $selectedYear',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(monthsKeys.length, (i) {
                    final bool sel = i == selectedMonthIndex;
                    return GestureDetector(
                      onTap: () => setState(() => selectedMonthIndex = i),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Text(
                          tr(monthsKeys[i]),
                          style: GoogleFonts.poppins(
                              color: sel ? Colors.white : Colors.grey[700],
                              fontSize: 13),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
      itemBuilder: (_) => ['2023', '2024', '2025', '2026']
          .map((y) => PopupMenuItem(value: y, child: Text(y)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)
          ],
        ),
        child: Row(
          children: [
            Text(selectedYear,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(int expense, int balance) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
                child: _quickStatCard('income'.tr(), formatCurrency(income),
                    Icons.trending_up, Colors.green)),
            const SizedBox(width: 12),
            Expanded(
                child: _quickStatCard('expense'.tr(), formatCurrency(expense),
                    Icons.trending_down, Colors.redAccent)),
            const SizedBox(width: 12),
            Expanded(
                child: _quickStatCard('balance'.tr(), formatCurrency(balance),
                    Icons.account_balance_wallet, AppColors.primary)),
          ],
        ),
      ),
    );
  }

  Widget _quickStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color)),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title,
                  style: GoogleFonts.poppins(
                      color: Colors.grey[600], fontSize: 12)),
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildChartSection(int expense) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            Expanded(flex: 5, child: _buildDonutChart(expense)),
            const SizedBox(width: 12),
            Expanded(flex: 5, child: _buildLegend()),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChart(int expense) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: _PiePainter(
              categories.map((e) => (e['value'] as int).toDouble()).toList(),
              categories.map((e) => e['color'] as Color).toList(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatCurrency(expense),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text('total_expense'.tr(),
                  style: GoogleFonts.poppins(
                      color: Colors.grey[600], fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: categories.map((c) {
        final int v = c['value'] as int;
        final pct = totalExpense == 0 ? 0.0 : (v / totalExpense);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: c['color'] as Color, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(c['name'] as String,
                      style: GoogleFonts.poppins(fontSize: 13))),
              Text('${(pct * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailedList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((ctx, i) {
          final c = categories[i];
          final v = c['value'] as int;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: c['color'] as Color,
                  child: const Icon(Icons.pie_chart,
                      color: Colors.white, size: 18)),
              title: Text(c['name'] as String,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text(formatCurrency(v),
                  style: GoogleFonts.poppins(color: Colors.grey[600])),
              trailing: SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                    value: totalExpense == 0 ? 0 : v / totalExpense,
                    color: c['color'] as Color,
                    backgroundColor: Colors.grey[200]),
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
    final stroke = radius * 0.45;
    double startRadian = -pi / 2;

    final rect = Rect.fromCircle(center: center, radius: radius - stroke / 2);

    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = colors[i];
      canvas.drawArc(rect, startRadian, sweep, false, paint);
      startRadian += sweep;
    }

    canvas.drawCircle(
        center, radius - stroke - 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PiePainter old) =>
      old.values != values || old.colors != colors;
}
