import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/signal_model.dart';

class StatsHeader extends StatelessWidget {
  final List<Signal> signals;

  const StatsHeader({super.key, required this.signals});

  @override
  Widget build(BuildContext context) {
    final active = signals.where((s) => s.status == SignalStatus.active).length;
    final closed = signals.where((s) => s.status == SignalStatus.closed).length;
    final winRate = closed > 0
        ? (signals
                    .where((s) =>
                        s.status == SignalStatus.closed && s.tpHit > 0)
                    .length /
                closed *
                100)
            .toStringAsFixed(0)
        : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFD4AF37).withOpacity(0.08),
                  const Color(0xFF0F1623).withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildStat(
                  icon: Icons.bolt_rounded,
                  iconColor: const Color(0xFFD4AF37),
                  value: '$active',
                  label: 'Active',
                ),
                _buildDivider(),
                _buildStat(
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF00C896),
                  value: winRate == '—' ? winRate : '$winRate%',
                  label: 'Win Rate',
                ),
                _buildDivider(),
                _buildStat(
                  icon: Icons.history_rounded,
                  iconColor: const Color(0xFF60A5FA),
                  value: '${signals.length}',
                  label: 'Total',
                ),
                _buildDivider(),
                _buildStat(
                  icon: Icons.trending_up_rounded,
                  iconColor: const Color(0xFFFF9F40),
                  value: '+18.4%',
                  label: 'MTD',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white38,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.08),
    );
  }
}
