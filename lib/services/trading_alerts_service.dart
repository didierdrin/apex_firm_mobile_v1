import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/signal_model.dart';

const _symbolLabels = {
  'GBPJPY=X': 'GBP/JPY',
  'XAUUSD=X': 'XAU/USD',
  'USDCAD=X': 'USD/CAD',
  'BTC-USD': 'BTC/USD',
  'EURUSD=X': 'EUR/USD',
  'GBPUSD=X': 'GBP/USD',
  'USDJPY=X': 'USD/JPY',
  'AUDJPY=X': 'AUD/JPY',
  'AUDUSD=X': 'AUD/USD',
  'NZDUSD=X': 'NZD/USD',
  'USDCHF=X': 'USD/CHF',
  'EURGBP=X': 'EUR/GBP',
  'EURCAD=X': 'EUR/CAD',
  'EURJPY=X': 'EUR/JPY',
  'GBPCAD=X': 'GBP/CAD',
  'AUDCAD=X': 'AUD/CAD',
  'EURAUD=X': 'EUR/AUD',
  'XAUEUR=X': 'XAU/EUR',
  'ETH-USD': 'ETH/USD',
};

class TradingAlertsService {
  TradingAlertsService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  /// Live feed from the same `trading_alerts` collection the bot writes to.
  Stream<List<Signal>> watchSignals({int limit = 50}) {
    Query<Map<String, dynamic>> query;
    try {
      query = _db
          .collection('trading_alerts')
          .orderBy('timestamp_ms', descending: true)
          .limit(limit);
    } catch (_) {
      query = _db.collection('trading_alerts').limit(limit);
    }

    return query.snapshots().map((snap) {
      final signals = snap.docs.map(_mapDoc).toList();
      signals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return signals.take(limit).toList();
    });
  }

  Signal _mapDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final symbol = data['symbol'] as String? ?? 'UNKNOWN';
    final typeRaw = (data['type'] as String? ?? 'BUY').toUpperCase();
    final price = (data['price'] as num?)?.toDouble() ?? 0.0;
    final createdAt = _parseTimestamp(data);

    final signalType = _mapSignalType(typeRaw);
    final status = typeRaw.startsWith('EXIT')
        ? SignalStatus.closed
        : SignalStatus.active;

    final offset = price * 0.005;

    return Signal(
      id: doc.id,
      pair: _symbolLabels[symbol] ?? symbol,
      type: signalType,
      status: status,
      assetClass: _assetClassFor(symbol),
      entryPrice: price,
      stopLoss: signalType == SignalType.buy ? price - offset : price + offset,
      takeProfit1: signalType == SignalType.buy ? price + offset : price - offset,
      takeProfit2: signalType == SignalType.buy ? price + offset * 2 : price - offset * 2,
      takeProfit3: signalType == SignalType.buy ? price + offset * 3 : price - offset * 3,
      currentPrice: price,
      analysis: _buildAnalysis(data),
      createdAt: createdAt,
      timeframe: data['timeframe'] as String? ?? '1h',
      riskRewardRatio: 3,
      isPremium: data['confidence'] == 'HIGH',
    );
  }

  DateTime _parseTimestamp(Map<String, dynamic> data) {
    final ms = data['timestamp_ms'];
    if (ms is num) {
      return DateTime.fromMillisecondsSinceEpoch(ms.toInt(), isUtc: true).toLocal();
    }

    final ts = data['timestamp'];
    if (ts is Timestamp) {
      return ts.toDate();
    }
    if (ts is String) {
      return DateTime.tryParse(ts) ?? DateTime.now();
    }
    if (ts is num) {
      final epoch = ts < 1e12 ? ts * 1000 : ts;
      return DateTime.fromMillisecondsSinceEpoch(epoch.toInt(), isUtc: true).toLocal();
    }

    final iso = data['timestamp_iso'] as String?;
    if (iso != null) {
      return DateTime.tryParse(iso) ?? DateTime.now();
    }

    return DateTime.now();
  }

  SignalType _mapSignalType(String typeRaw) {
    if (typeRaw == 'SELL' || typeRaw == 'EXIT_LONG') {
      return SignalType.sell;
    }
    return SignalType.buy;
  }

  AssetClass _assetClassFor(String symbol) {
    if (symbol.contains('BTC') || symbol.contains('ETH')) {
      return AssetClass.crypto;
    }
    if (symbol.contains('XAU')) {
      return AssetClass.commodities;
    }
    return AssetClass.forex;
  }

  String _buildAnalysis(Map<String, dynamic> data) {
    final signal = data['signal'] as String? ?? '';
    final z = data['zscore'];
    final session = data['session'] as String? ?? '';
    final zText = z != null ? 'Z-score: ${(z as num).toStringAsFixed(2)}. ' : '';
    return '$zText${signal.replaceAll('_', ' ')}. Session: $session.';
  }
}
