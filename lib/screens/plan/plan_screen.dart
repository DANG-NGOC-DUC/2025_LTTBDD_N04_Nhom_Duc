import 'package:flutter/material.dart';
import 'package:my_app/theme/app_colors.dart';
import 'package:my_app/widgets/bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final List<Map<String, dynamic>> _plansData = [
    {
      "titleKey": "plan_saving_oct",
      "budget": 5000000,
      "spent": 2500000,
      "startDate": "01/10/2025",
      "endDate": "31/10/2025",
      "categoryKey": "cat_general",
      "color": const Color(0xFF4CAF50),
      "icon": Icons.savings_rounded,
      "statusKey": "status_ongoing"
    },
    {
      "titleKey": "plan_year_trip",
      "budget": 15000000,
      "spent": 3000000,
      "startDate": "01/11/2025",
      "endDate": "31/12/2025",
      "categoryKey": "cat_entertainment",
      "color": const Color(0xFF2196F3),
      "icon": Icons.flight_rounded,
      "statusKey": "status_upcoming"
    },
    {
      "titleKey": "plan_new_laptop",
      "budget": 20000000,
      "spent": 15000000,
      "startDate": "01/09/2025",
      "endDate": "30/09/2025",
      "categoryKey": "cat_shopping",
      "color": const Color(0xFFFF9800),
      "icon": Icons.laptop_rounded,
      "statusKey": "status_completed"
    },
  ];

  List<Map<String, dynamic>> get plans => _plansData;

  String selectedFilterKey = "filter_all";
  
  List<Map<String, String>> get filters => [
    {"key": "filter_all"},
    {"key": "status_ongoing"},
    {"key": "status_upcoming"},
    {"key": "status_completed"},
  ];

  String formatCurrency(int value) =>
      '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';

  @override
  Widget build(BuildContext context) {
    final filteredPlans = selectedFilterKey == "filter_all"
        ? plans
        : plans.where((p) => p['statusKey'] == selectedFilterKey).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildFilterTabs(),
          _buildStatisticsCards(),
          _buildPlansList(filteredPlans),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlanDialog,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('plan_title'.tr(),
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
        background: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7)
          ])),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('total_plans'.tr(),
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 12)),
                  Text('${plans.length}',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'search'.tr(),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          tooltip: 'more_options'.tr(),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            bool isSelected = filter['key'] == selectedFilterKey;
            return GestureDetector(
              onTap: () => setState(() => selectedFilterKey = filter['key']!),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Text(filter['key']!.tr(),
                    style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
                child: _buildQuickStatCard(
                    'status_ongoing'.tr(),
                    plans
                        .where((p) => p['statusKey'] == 'status_ongoing')
                        .length
                        .toString(),
                    Icons.pending_actions_rounded,
                    const Color(0xFF4CAF50))),
            const SizedBox(width: 12),
            Expanded(
                child: _buildQuickStatCard(
                    'status_completed'.tr(),
                    plans
                        .where((p) => p['statusKey'] == 'status_completed')
                        .length
                        .toString(),
                    Icons.check_circle_rounded,
                    const Color(0xFF2196F3))),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text(title,
                    style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(List<Map<String, dynamic>> filteredPlans) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: filteredPlans.isEmpty
          ? SliverToBoxAdapter(child: _buildEmptyState())
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPlanCard(filteredPlans[index]),
                  childCount: filteredPlans.length)),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final double progress = (plan['spent'] as int) / (plan['budget'] as int);
    final int remaining = (plan['budget'] as int) - (plan['spent'] as int);
    final String statusKey = plan['statusKey'] as String;
    final Color statusColor = _getStatusColor(statusKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ]),
      child: Column(
        children: [
          _buildPlanHeader(plan, statusColor),
          _buildPlanContent(plan, progress, remaining),
        ],
      ),
    );
  }

  Widget _buildPlanHeader(Map<String, dynamic> plan, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: (plan['color'] as Color).withOpacity(0.1),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: plan['color'] as Color,
                borderRadius: BorderRadius.circular(12)),
            child:
                Icon(plan['icon'] as IconData, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((plan['titleKey'] as String).tr(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.category_rounded,
                        size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text((plan['categoryKey'] as String).tr(),
                        style: GoogleFonts.poppins(
                            color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20)),
            child: Text((plan['statusKey'] as String).tr(),
                style: GoogleFonts.poppins(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanContent(
      Map<String, dynamic> plan, double progress, int remaining) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBudgetInfo(
                  'budget'.tr(),
                  formatCurrency(plan['budget'] as int),
                  plan['color'] as Color),
              _buildBudgetInfo('remaining'.tr(), formatCurrency(remaining),
                  remaining > 0 ? Colors.green : Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          _buildProgressSection(plan, progress),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text('${plan['startDate']} - ${plan['endDate']}',
                  style: GoogleFonts.poppins(
                      color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: label == 'budget'.tr()
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, fontSize: 16, color: color)),
      ],
    );
  }

  Widget _buildProgressSection(Map<String, dynamic> plan, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'progress'.tr(namedArgs: {
                  'percent': (progress * 100).toStringAsFixed(0)
                }),
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700])),
            Text(formatCurrency(plan['spent'] as int),
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation<Color>(plan['color'] as Color)),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.folder_open_rounded, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('no_plans'.tr(),
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text('create_first_plan'.tr(),
              style:
                  GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Color _getStatusColor(String statusKey) {
    switch (statusKey) {
      case 'status_ongoing':
        return const Color(0xFF4CAF50);
      case 'status_upcoming':
        return const Color(0xFF2196F3);
      case 'status_completed':
        return const Color(0xFF9E9E9E);
      default:
        return Colors.grey;
    }
  }

  void _showAddPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('add_new_plan'.tr(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content:
            Text('feature_in_development'.tr(), style: GoogleFonts.poppins()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('close'.tr()))
        ],
      ),
    );
  }
}
