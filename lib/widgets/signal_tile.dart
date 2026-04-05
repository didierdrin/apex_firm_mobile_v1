import 'package:flutter/material.dart';
import '../models/signal_model.dart';
import 'package:intl/intl.dart';

class SignalTile extends StatelessWidget {
  final Signal signal;
  final VoidCallback onTap;

  const SignalTile({
    super.key,
    required this.signal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1623),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1E2A3A),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildIcon(),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signal.pair,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          signal.assetClassLabel,
                          style: const TextStyle(
                            color: Color(0xFF8A94A6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildTypeBadge(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('ENTRY', signal.entryPrice.toString()),
                _buildInfoColumn('TP 1', signal.takeProfit1.toString()),
                _buildInfoColumn('SL', signal.stopLoss.toString()),
                _buildPnlIndicator(),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF1E2A3A), height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd, HH:mm').format(signal.createdAt),
                  style: const TextStyle(color: Color(0xFF8A94A6), fontSize: 11),
                ),
                Text(
                  signal.timeframe,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF080C14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          signal.assetClass == AssetClass.crypto
              ? Icons.currency_bitcoin_rounded
              : signal.assetClass == AssetClass.commodities
                  ? Icons.reorder_rounded
                  : Icons.currency_exchange_rounded,
          color: const Color(0xFFD4AF37),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    final isBuy = signal.type == SignalType.buy;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isBuy ? const Color(0xFF00C896) : const Color(0xFFFF5252))
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: (isBuy ? const Color(0xFF00C896) : const Color(0xFFFF5252))
              .withOpacity(0.3),
        ),
      ),
      child: Text(
        signal.typeLabel,
        style: TextStyle(
          color: isBuy ? const Color(0xFF00C896) : const Color(0xFFFF5252),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A94A6),
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPnlIndicator() {
    if (signal.status == SignalStatus.pending) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'PNL',
            style: TextStyle(color: Color(0xFF8A94A6), fontSize: 10),
          ),
          SizedBox(height: 2),
          Text(
            'PENDING',
            style: TextStyle(
              color: Color(0xFF4D9FFF),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    final pips = signal.pnlPips ?? 0;
    final isProfit = pips >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'PNL',
          style: TextStyle(color: Color(0xFF8A94A6), fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          '${isProfit ? '+' : ''}$pips PIPS',
          style: TextStyle(
            color: isProfit ? const Color(0xFF00C896) : const Color(0xFFFF5252),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
