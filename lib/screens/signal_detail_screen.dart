import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/signal_model.dart';

class SignalDetailScreen extends StatelessWidget {
  final Signal signal;

  const SignalDetailScreen({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C14),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _buildBackground(),
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildOverviewCard(),
                      const SizedBox(height: 16),
                      _buildEntryCard(),
                      const SizedBox(height: 16),
                      _buildTakeProfitCard(),
                      const SizedBox(height: 16),
                      _buildStopLossCard(),
                      const SizedBox(height: 16),
                      if (signal.note != null) _buildNoteCard(),
                      const SizedBox(height: 16),
                      _buildPriceProgressCard(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF060A12), Color(0xFF080C14)],
            ),
          ),
        ),
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  signal.directionColor.withOpacity(0.15),
                  signal.directionColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: const Color(0xFF080C14),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    signal.directionColor.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _badge(signal.directionLabel,
                          signal.directionColor.withOpacity(0.2),
                          signal.directionColor, FontWeight.w800),
                      const SizedBox(width: 8),
                      _badge(signal.statusLabel,
                          signal.statusColor.withOpacity(0.15),
                          signal.statusColor, FontWeight.w600),
                      const Spacer(),
                      Text(
                        'ID: ${signal.id}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 11,
                          color: Colors.white30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    signal.asset,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    signal.assetPair,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color fg, FontWeight fw) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: GoogleFonts.outfit(
              fontSize: 12, fontWeight: fw, color: fg, letterSpacing: 1.2)),
    );
  }

  Widget _buildOverviewCard() {
    final pnl = signal.pnlPercent;
    return _glassCard(
      child: Row(
        children: [
          Expanded(
            child: _statItem(
              label: 'CURRENT P&L',
              value: '${pnl >= 0 ? '+' : ''}${pnl.toStringAsFixed(2)}%',
              color: pnl >= 0 ? const Color(0xFF00C896) : const Color(0xFFFF5252),
              icon: pnl >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            ),
          ),
          _vDivider(),
          Expanded(
            child: _statItem(
              label: 'RISK:REWARD',
              value: '1 : ${signal.riskRewardRatio.toStringAsFixed(1)}',
              color: const Color(0xFFD4AF37),
              icon: Icons.balance_rounded,
            ),
          ),
          _vDivider(),
          Expanded(
            child: _statItem(
              label: 'TPs HIT',
              value: '${signal.tpHit} / ${signal.takeProfits.length}',
              color: const Color(0xFF60A5FA),
              icon: Icons.flag_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('ENTRY', Icons.login_rounded, const Color(0xFFD4AF37)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _infoRow('Entry Price', _fmtPrice(signal.entryPrice), Colors.white)),
              Expanded(child: _infoRow('Entry Time', DateFormat('HH:mm · MMM dd').format(signal.entryTime), Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _infoRow('Asset Class', signal.assetClassLabel, Colors.white70)),
              Expanded(
                child: _infoRow(
                  'Current Price',
                  signal.currentPrice != null ? _fmtPrice(signal.currentPrice!) : '—',
                  signal.pnlPercent >= 0 ? const Color(0xFF00C896) : const Color(0xFFFF5252),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTakeProfitCard() {
    return _glassCard(
      borderColor: const Color(0xFF00C896).withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('TAKE PROFITS', Icons.flag_rounded, const Color(0xFF00C896)),
          const SizedBox(height: 14),
          ...List.generate(signal.takeProfits.length, (i) {
            final isHit = i < signal.tpHit;
            final tp = signal.takeProfits[i];
            final pct = ((tp - signal.entryPrice) / (signal.entryPrice > 10 ? signal.entryPrice : 1) * 100).abs();
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isHit ? const Color(0xFF00C896).withOpacity(0.08) : Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHit ? const Color(0xFF00C896).withOpacity(0.3) : Colors.white.withOpacity(0.07),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isHit ? const Color(0xFF00C896).withOpacity(0.2) : Colors.white.withOpacity(0.06),
                      ),
                      child: isHit
                          ? const Icon(Icons.check_rounded, color: Color(0xFF00C896), size: 16)
                          : Text('${i + 1}', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white54, fontSize: 13)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Take Profit ${i + 1}', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(_fmtPrice(tp), style: GoogleFonts.robotoMono(fontSize: 16, fontWeight: FontWeight.w700, color: isHit ? const Color(0xFF00C896) : Colors.white)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isHit ? 'REACHED ✓' : 'TARGET',
                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: isHit ? const Color(0xFF00C896) : Colors.white30, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 2),
                        Text('+${pct.toStringAsFixed(2)}%', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF00C896).withOpacity(0.7))),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStopLossCard() {
    final slPct = ((signal.stopLoss - signal.entryPrice) / signal.entryPrice * 100).abs();
    return _glassCard(
      borderColor: const Color(0xFFFF5252).withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('STOP LOSS', Icons.shield_rounded, const Color(0xFFFF5252)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFFFF5252).withOpacity(0.08), Colors.transparent]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF5252).withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stop Loss Price', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54)),
                    const SizedBox(height: 4),
                    Text(_fmtPrice(signal.stopLoss), style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFFFF5252))),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Risk', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54)),
                    const SizedBox(height: 4),
                    Text('-${slPct.toStringAsFixed(2)}%', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFFFF5252))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('ANALYST NOTE', Icons.notes_rounded, const Color(0xFF60A5FA)),
          const SizedBox(height: 12),
          Text(signal.note!, style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildPriceProgressCard(BuildContext context) {
    final currentPrice = signal.currentPrice ?? signal.entryPrice;
    final highTarget = signal.takeProfits.last;
    final lowBound = signal.stopLoss;
    final range = (highTarget - lowBound).abs();
    final progress = range > 0 ? ((currentPrice - lowBound) / range).clamp(0.0, 1.0) : 0.5;

    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('PRICE RANGE', Icons.linear_scale_rounded, const Color(0xFFD4AF37)),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final dotLeft = (progress * barWidth - 7).clamp(0.0, barWidth - 14);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress.toDouble(),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF5252), Color(0xFF00C896)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: dotLeft,
                    top: -3,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 6)],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SL: ${_fmtPrice(signal.stopLoss)}', style: GoogleFonts.robotoMono(fontSize: 11, color: const Color(0xFFFF5252))),
              Text('Now: ${_fmtPrice(currentPrice)}', style: GoogleFonts.robotoMono(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w700)),
              Text('TP${signal.takeProfits.length}: ${_fmtPrice(highTarget)}', style: GoogleFonts.robotoMono(fontSize: 11, color: const Color(0xFF00C896))),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Shared helpers ───────────────────────────────────────────────────────

  Widget _glassCard({required Widget child, Color? borderColor}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.07), Colors.white.withOpacity(0.02)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor ?? Colors.white.withOpacity(0.08), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _statItem({required String label, required String value, required Color color, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.robotoMono(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 3),
        Text(label, style: GoogleFonts.outfit(fontSize: 9, color: Colors.white38, letterSpacing: 0.8), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _vDivider() => Container(width: 1, height: 50, color: Colors.white.withOpacity(0.08));

  Widget _infoRow(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
      ],
    );
  }

  String _fmtPrice(double price) {
    if (price > 1000) return NumberFormat('#,##0.00').format(price);
    if (price > 10) return price.toStringAsFixed(3);
    return price.toStringAsFixed(5);
  }
}
