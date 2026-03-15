import 'package:flutter/material.dart';

enum SignalDirection { long, short }

enum SignalStatus { active, closed, pending }

enum AssetClass { forex, crypto, commodities, indices, stocks }

class Signal {
  final String id;
  final String asset;
  final String assetPair;
  final SignalDirection direction;
  final SignalStatus status;
  final double entryPrice;
  final List<double> takeProfits;
  final double stopLoss;
  final DateTime entryTime;
  final AssetClass assetClass;
  final String? note;
  final double? currentPrice;
  final int tpHit; // how many TPs have been hit (0 = none)

  const Signal({
    required this.id,
    required this.asset,
    required this.assetPair,
    required this.direction,
    required this.status,
    required this.entryPrice,
    required this.takeProfits,
    required this.stopLoss,
    required this.entryTime,
    required this.assetClass,
    this.note,
    this.currentPrice,
    this.tpHit = 0,
  });

  Color get directionColor =>
      direction == SignalDirection.long
          ? const Color(0xFF00C896)
          : const Color(0xFFFF5252);

  String get directionLabel =>
      direction == SignalDirection.long ? 'LONG' : 'SHORT';

  Color get statusColor {
    switch (status) {
      case SignalStatus.active:
        return const Color(0xFFD4AF37);
      case SignalStatus.closed:
        return const Color(0xFF6B7280);
      case SignalStatus.pending:
        return const Color(0xFF60A5FA);
    }
  }

  String get statusLabel {
    switch (status) {
      case SignalStatus.active:
        return 'ACTIVE';
      case SignalStatus.closed:
        return 'CLOSED';
      case SignalStatus.pending:
        return 'PENDING';
    }
  }

  String get assetClassLabel {
    switch (assetClass) {
      case AssetClass.forex:
        return 'FX';
      case AssetClass.crypto:
        return 'CRYPTO';
      case AssetClass.commodities:
        return 'COMM';
      case AssetClass.indices:
        return 'INDEX';
      case AssetClass.stocks:
        return 'STOCK';
    }
  }

  IconData get assetIcon {
    switch (assetClass) {
      case AssetClass.forex:
        return Icons.currency_exchange;
      case AssetClass.crypto:
        return Icons.currency_bitcoin;
      case AssetClass.commodities:
        return Icons.oil_barrel;
      case AssetClass.indices:
        return Icons.show_chart;
      case AssetClass.stocks:
        return Icons.business;
    }
  }

  double get riskRewardRatio {
    if (takeProfits.isEmpty) return 0;
    final tp1 = takeProfits.first;
    final risk = (entryPrice - stopLoss).abs();
    final reward = (tp1 - entryPrice).abs();
    return risk > 0 ? reward / risk : 0;
  }

  double get pnlPercent {
    final price = currentPrice ?? entryPrice;
    if (direction == SignalDirection.long) {
      return ((price - entryPrice) / entryPrice) * 100;
    } else {
      return ((entryPrice - price) / entryPrice) * 100;
    }
  }
}
