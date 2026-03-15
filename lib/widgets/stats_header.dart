import 'package:flutter/material.dart';
import '../models/signal_model.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2035), Color(0xFF0F1623)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance',
                    style: TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '87.5',
                          style: TextStyle(
                            color: Color(0xFF00C896),
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            color: Color(0xFF00C896),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Win Rate',
                    style: TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C896).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00C896).withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: Color(0xFF00C896),
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Color(0xFF00C896),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats row
          Row(
            children: [
              _StatItem(
                label: 'Total Pips',
                value: '+696',
                color: const Color(0xFF00C896),
                icon: Icons.show_chart_rounded,
              ),
              _Divider(),
              _StatItem(
                label: 'Avg R:R',
                value: '1:3.6',
                color: const Color(0xFFD4AF37),
                icon: Icons.balance_rounded,
              ),
              _Divider(),
              _StatItem(
                label: 'Active',
                value: '5',
                color: const Color(0xFF4D9FFF),
                icon: Icons.bolt_rounded,
              ),
              _Divider(),
              _StatItem(
                label: 'Closed',
                value: '2',
                color: const Color(0xFF8A94A6),
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8A94A6),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: const Color(0xFF1E2A3A),
    );
  }
}

// Filter chip for signal types
class FilterChipRow extends StatefulWidget {
  final Function(String) onFilterChanged;
  final Function(AssetClass?) onAssetClassChanged;

  const FilterChipRow({
    super.key,
    required this.onFilterChanged,
    required this.onAssetClassChanged,
  });

  @override
  State<FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<FilterChipRow> {
  String _selectedStatus = 'All';
  AssetClass? _selectedAsset;

  final List<String> _statusFilters = ['All', 'Active', 'Pending', 'Closed'];
  final List<Map<String, dynamic>> _assetFilters = [
    {'label': 'All Assets', 'value': null},
    {'label': 'Forex', 'value': AssetClass.forex},
    {'label': 'Crypto', 'value': AssetClass.crypto},
    {'label': 'Commodities', 'value': AssetClass.commodities},
    {'label': 'Indices', 'value': AssetClass.indices},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status filters
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _statusFilters.length,
            itemBuilder: (context, index) {
              final filter = _statusFilters[index];
              final isSelected = _selectedStatus == filter;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedStatus = filter);
                  widget.onFilterChanged(filter);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF0F1623),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFF1E2A3A),
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF080C14)
                          : const Color(0xFF8A94A6),
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Asset class filters
        SizedBox(
          height: 32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _assetFilters.length,
            itemBuilder: (context, index) {
              final filter = _assetFilters[index];
              final isSelected = _selectedAsset == filter['value'];
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAsset = filter['value']);
                  widget.onAssetClassChanged(filter['value']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4D9FFF).withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4D9FFF).withOpacity(0.5)
                          : const Color(0xFF1E2A3A),
                    ),
                  ),
                  child: Text(
                    filter['label'] as String,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF4D9FFF)
                          : const Color(0xFF8A94A6),
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
