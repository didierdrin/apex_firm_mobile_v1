import 'package:flutter/material.dart';
import '../models/signal_model.dart';
import '../services/trading_alerts_service.dart';
import '../widgets/stats_header.dart';
import '../widgets/signal_tile.dart';
import 'signal_detail_screen.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key});

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  final TradingAlertsService _alertsService = TradingAlertsService();
  String _statusFilter = 'All';
  AssetClass? _assetFilter;

  List<Signal> _filterSignals(List<Signal> signals) {
    return signals.where((signal) {
      final statusMatch = _statusFilter == 'All' ||
          signal.statusLabel.toLowerCase() == _statusFilter.toLowerCase();
      final assetMatch =
          _assetFilter == null || signal.assetClass == _assetFilter;
      return statusMatch && assetMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const StatsHeader(),
            const SizedBox(height: 16),
            FilterChipRow(
              onFilterChanged: (filter) => setState(() => _statusFilter = filter),
              onAssetClassChanged: (asset) => setState(() => _assetFilter = asset),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Signal>>(
                stream: _alertsService.watchSignals(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Could not load live signals.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF8A94A6)),
                        ),
                      ),
                    );
                  }

                  final signals = _filterSignals(snapshot.data ?? []);
                  return _buildSignalsList(signals);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'APEX FUNDS',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Trading Signals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F1623),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E2A3A)),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalsList(List<Signal> signals) {
    if (signals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.radar_rounded, color: Color(0xFF8A94A6), size: 48),
            SizedBox(height: 16),
            Text(
              'No live signals yet',
              style: TextStyle(color: Color(0xFF8A94A6), fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bot is monitoring markets — new alerts appear here automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF5A6478), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: signals.length,
      itemBuilder: (context, index) {
        final signal = signals[index];
        return SignalTile(
          signal: signal,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignalDetailScreen(signal: signal),
              ),
            );
          },
        );
      },
    );
  }
}
