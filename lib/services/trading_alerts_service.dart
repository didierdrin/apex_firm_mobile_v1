import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/signal_model.dart';

const _symbolLabels = {
  'EURUSD=X': 'EUR/USD', 'GBPJPY=X': 'GBP/JPY', 'AUDJPY=X': 'AUD/JPY',
  'XAUUSD=X': 'XAU/USD', 'USDCAD=X': 'USD/CAD', 'GBPUSD=X': 'GBP/USD',
  'EURJPY=X': 'EUR/JPY', 'USDJPY=X': 'USD/JPY', 'AUDUSD=X': 'AUD/USD',
  'NZDUSD=X': 'NZD/USD', 'USDCHF=X': 'USD/CHF', 'EURGBP=X': 'EUR/GBP',
  'EURCAD=X': 'EUR/CAD', 'GBPCAD=X': 'GBP/CAD', 'AUDCAD=X': 'AUD/CAD',
  'EURAUD=X': 'EUR/AUD', 'EURCHF=X': 'EUR/CHF', 'EURNZD=X': 'EUR/NZD',
  'GBPCHF=X': 'GBP/CHF', 'GBPAUD=X': 'GBP/AUD', 'GBPNZD=X': 'GBP/NZD',
  'AUDCHF=X': 'AUD/CHF', 'AUDNZD=X': 'AUD/NZD', 'CADJPY=X': 'CAD/JPY',
  'CHFJPY=X': 'CHF/JPY', 'NZDJPY=X': 'NZD/JPY', 'NZDCAD=X': 'NZD/CAD',
  'NZDCHF=X': 'NZD/CHF', 'CADCHF=X': 'CAD/CHF', 'XAUEUR=X': 'XAU/EUR',
  'XAUGBP=X': 'XAU/GBP', 'XAUJPY=X': 'XAU/JPY', 'XAGUSD=X': 'XAG/USD',
  'USDMXN=X': 'USD/MXN', 'USDZAR=X': 'USD/ZAR', 'USDTRY=X': 'USD/TRY',
  'USDSEK=X': 'USD/SEK', 'USDNOK=X': 'USD/NOK', 'USDDKK=X': 'USD/DKK',
  'USDPLN=X': 'USD/PLN', 'USDSGD=X': 'USD/SGD', 'USDHKD=X': 'USD/HKD',
  'USDCNH=X': 'USD/CNH',
  'BTC-USD': 'BTC/USD', 'ETH-USD': 'ETH/USD', 'SOL-USD': 'SOL/USD',
  'BNB-USD': 'BNB/USD', 'XRP-USD': 'XRP/USD', 'ADA-USD': 'ADA/USD',
  'DOGE-USD': 'DOGE/USD', 'DOT-USD': 'DOT/USD', 'AVAX-USD': 'AVAX/USD',
  'LINK-USD': 'LINK/USD', 'LTC-USD': 'LTC/USD', 'BCH-USD': 'BCH/USD',
  'MATIC-USD': 'MATIC/USD', 'UNI-USD': 'UNI/USD', 'ATOM-USD': 'ATOM/USD',
  'XLM-USD': 'XLM/USD', 'SHIB-USD': 'SHIB/USD', 'TRX-USD': 'TRX/USD',
  '^GSPC': 'S&P 500', '^DJI': 'Dow Jones', '^IXIC': 'Nasdaq', '^RUT': 'Russell 2000',
  '^VIX': 'VIX', '^FTSE': 'FTSE 100', '^GDAXI': 'DAX', '^FCHI': 'CAC 40',
  '^N225': 'Nikkei 225', '^HSI': 'Hang Seng', '^STOXX50E': 'Euro Stoxx 50',
  'GC=F': 'Gold Futures', 'SI=F': 'Silver Futures', 'CL=F': 'WTI Oil',
  'BZ=F': 'Brent Oil', 'NG=F': 'Natural Gas', 'HG=F': 'Copper',
  'ZC=F': 'Corn', 'ZW=F': 'Wheat',
  'AAPL': 'Apple', 'MSFT': 'Microsoft', 'GOOGL': 'Alphabet', 'GOOG': 'Alphabet C',
  'AMZN': 'Amazon', 'META': 'Meta', 'NVDA': 'NVIDIA', 'TSLA': 'Tesla',
  'AMD': 'AMD', 'INTC': 'Intel', 'NFLX': 'Netflix', 'CRM': 'Salesforce',
  'ORCL': 'Oracle', 'IBM': 'IBM', 'JPM': 'JPMorgan', 'BAC': 'Bank of America',
  'WFC': 'Wells Fargo', 'GS': 'Goldman Sachs', 'V': 'Visa', 'MA': 'Mastercard',
  'JNJ': 'J&J', 'UNH': 'UnitedHealth', 'PFE': 'Pfizer', 'XOM': 'Exxon',
  'CVX': 'Chevron', 'WMT': 'Walmart', 'HD': 'Home Depot', 'DIS': 'Disney',
  'KO': 'Coca-Cola', 'PEP': 'PepsiCo', 'NKE': 'Nike', 'BA': 'Boeing',
  'COIN': 'Coinbase', 'MSTR': 'MicroStrategy',
  'SPY': 'S&P 500 ETF', 'QQQ': 'Nasdaq ETF', 'DIA': 'Dow ETF', 'IWM': 'Russell ETF',
  'XLF': 'Financials ETF', 'XLE': 'Energy ETF', 'XLK': 'Tech ETF',
  'GLD': 'Gold ETF', 'SLV': 'Silver ETF', 'USO': 'Oil ETF',
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
    if (symbol.startsWith('^')) {
      return AssetClass.indices;
    }
    if (symbol.endsWith('=F')) {
      return AssetClass.commodities;
    }
    if (symbol.endsWith('-USD')) {
      return AssetClass.crypto;
    }
    if (symbol.contains('XAU') || symbol.contains('XAG')) {
      return AssetClass.commodities;
    }
    if (symbol.endsWith('=X')) {
      return AssetClass.forex;
    }
    return AssetClass.stocks;
  }

  String _buildAnalysis(Map<String, dynamic> data) {
    final signal = data['signal'] as String? ?? '';
    final z = data['zscore'];
    final session = data['session'] as String? ?? '';
    final zText = z != null ? 'Z-score: ${(z as num).toStringAsFixed(2)}. ' : '';
    return '$zText${signal.replaceAll('_', ' ')}. Session: $session.';
  }
}
