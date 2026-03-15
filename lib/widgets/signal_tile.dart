import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/signal_model.dart';

class SignalTile extends StatelessWidget {
  final Signal signal;
  final VoidCallback onTap;

  const SignalTile({super.key, required this.signal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.07),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: signal.direction == SignalDirection.long
                    ? const Color(0xFF00C896).withOpacity(0.2)
                    : const Color(0xFFFF5252).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Direction accent bar
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: signal.direction == SignalDirection.long
                          ? [
                              const Color(0xFF00C896),
                              const Color(0xFF00C896).withOpacity(0.0),
                            ]
                          : [
                              const Color(0xFFFF5252),
                              const Color(0xFFFF5252).withOpacity(0.0),
                            ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTopRow(),
                      const SizedBox(height: 14),
                      _buildPriceRow(),
                      const SizedBox(height: 14),
                      _buildTPSLRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        // Asset icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: signal.directionColor.withOpacity(0.12),
            border: Border.all(
              color: signal.directionColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            signal.assetIcon,
            color: signal.directionColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),

        // Asset name & time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    signal.asset,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      signal.assetClassLabel,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: Colors.white38,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(signal.entryTime),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.white38,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Direction + Status column
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Direction badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: signal.directionColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: signal.directionColor.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    signal.direction == SignalDirection.long
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: signal.directionColor,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    signal.directionLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: signal.directionColor,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: signal.statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                signal.statusLabel,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: signal.statusColor,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    final pnl = signal.pnlPercent;
    final isPositive = pnl >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Entry price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ENTRY',
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatPrice(signal.entryPrice),
                  style: GoogleFonts.robotoMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 32,
            color: Colors.white.withOpacity(0.1),
          ),

          // PnL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'P&L',
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 14,
                      color: isPositive
                          ? const Color(0xFF00C896)
                          : const Color(0xFFFF5252),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${pnl.toStringAsFixed(2)}%',
                      style: GoogleFonts.robotoMono(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isPositive
                            ? const Color(0xFF00C896)
                            : const Color(0xFFFF5252),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 32,
            color: Colors.white.withOpacity(0.1),
          ),

          // R:R
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R:R RATIO',
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '1 : ${signal.riskRewardRatio.toStringAsFixed(1)}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTPSLRow() {
    return Row(
      children: [
        // Take Profits
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TAKE PROFITS',
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(signal.takeProfits.length, (i) {
                  final isHit = i < signal.tpHit;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHit
                            ? const Color(0xFF00C896).withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: isHit
                              ? const Color(0xFF00C896).withOpacity(0.5)
                              : Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isHit)
                            const Padding(
                              padding: EdgeInsets.only(right: 3),
                              child: Icon(
                                Icons.check_rounded,
                                size: 10,
                                color: Color(0xFF00C896),
                              ),
                            ),
                          Text(
                            'TP${i + 1}',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isHit
                                  ? const Color(0xFF00C896)
                                  : Colors.white54,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Stop Loss
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF5252).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFF5252).withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    size: 10,
                    color: Color(0xFFFF5252),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'STOP LOSS',
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF5252).withOpacity(0.8),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                _formatPrice(signal.stopLoss),
                style: GoogleFonts.robotoMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF5252),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago · ${DateFormat('HH:mm').format(time)}';
    } else {
      return DateFormat('MMM dd · HH:mm').format(time);
    }
  }

  String _formatPrice(double price) {
    if (price > 1000) {
      return NumberFormat('#,##0.00').format(price);
    } else if (price > 10) {
      return price.toStringAsFixed(3);
    } else {
      return price.toStringAsFixed(5);
    }
  }
}
