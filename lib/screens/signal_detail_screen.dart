import 'package:flutter/material.dart';
import '../models/signal_model.dart';
import 'package:intl/intl.dart';

class SignalDetailScreen extends StatelessWidget {
  final Signal signal;

  const SignalDetailScreen({
    super.key,
    required this.signal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Signal Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTradeParameters(),
            const SizedBox(height: 24),
            _buildAnalysis(),
            const SizedBox(height: 32),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1623),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E2A3A)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signal.pair,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${signal.assetClassLabel} • ${signal.timeframe}',
                    style: const TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              _buildLargeTypeBadge(),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF1E2A3A)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailStat('Status', signal.statusLabel,
                  signal.status == SignalStatus.active ? const Color(0xFF4D9FFF) : const Color(0xFF8A94A6)),
              _buildDetailStat('R:R Ratio', '1:${signal.riskRewardRatio}', const Color(0xFFD4AF37)),
              _buildDetailStat('Result', '${(signal.pnlPips ?? 0) >= 0 ? '+' : ''}${signal.pnlPips ?? 0} Pips',
                  (signal.pnlPips ?? 0) >= 0 ? const Color(0xFF00C896) : const Color(0xFFFF5252)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeTypeBadge() {
    final isBuy = signal.type == SignalType.buy;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (isBuy ? const Color(0xFF00C896) : const Color(0xFFFF5252)).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (isBuy ? const Color(0xFF00C896) : const Color(0xFFFF5252)).withOpacity(0.5)),
      ),
      child: Text(
        signal.typeLabel,
        style: TextStyle(
          color: isBuy ? const Color(0xFF00C896) : const Color(0xFFFF5252),
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8A94A6), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildTradeParameters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TRADE PARAMETERS',
          style: TextStyle(
            color: Color(0xFF8A94A6),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildParamRow('Entry Price', signal.entryPrice.toString(), const Color(0xFF4D9FFF)),
        _buildParamRow('Stop Loss', signal.stopLoss.toString(), const Color(0xFFFF5252)),
        _buildParamRow('Take Profit 1', signal.takeProfit1.toString(), const Color(0xFF00C896)),
        _buildParamRow('Take Profit 2', signal.takeProfit2.toString(), const Color(0xFF00C896)),
        _buildParamRow('Take Profit 3', signal.takeProfit3.toString(), const Color(0xFF00C896)),
      ],
    );
  }

  Widget _buildParamRow(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1623),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TECHNICAL ANALYSIS',
          style: TextStyle(
            color: Color(0xFF8A94A6),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1623),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            signal.analysis,
            style: const TextStyle(
              color: Color(0xFFD1D5DB),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('COPY SIGNAL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1623),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E2A3A)),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            padding: const EdgeInsets.all(16),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
