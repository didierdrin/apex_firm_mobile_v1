enum SignalType { buy, sell }
enum SignalStatus { active, closed, pending }
enum AssetClass { forex, crypto, stocks, commodities, indices }

class Signal {
  final String id;
  final String pair;
  final SignalType type;
  final SignalStatus status;
  final AssetClass assetClass;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit1;
  final double takeProfit2;
  final double takeProfit3;
  final double? currentPrice;
  final double? pnlPips;
  final String analysis;
  final DateTime createdAt;
  final DateTime? closedAt;
  final String timeframe;
  final int riskRewardRatio;
  final bool isPremium;

  const Signal({
    required this.id,
    required this.pair,
    required this.type,
    required this.status,
    required this.assetClass,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit1,
    required this.takeProfit2,
    required this.takeProfit3,
    this.currentPrice,
    this.pnlPips,
    required this.analysis,
    required this.createdAt,
    this.closedAt,
    required this.timeframe,
    required this.riskRewardRatio,
    this.isPremium = false,
  });

  bool get isProfit => (pnlPips ?? 0) > 0;

  String get typeLabel => type == SignalType.buy ? 'BUY' : 'SELL';

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
        return 'Forex';
      case AssetClass.crypto:
        return 'Crypto';
      case AssetClass.stocks:
        return 'Stocks';
      case AssetClass.commodities:
        return 'Commodities';
      case AssetClass.indices:
        return 'Indices';
    }
  }
}
