import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/signal_model.dart';

class FilterChipRow extends StatelessWidget {
  final AssetClass? selectedAsset;
  final Function(AssetClass) onAssetSelected;

  const FilterChipRow({
    super.key,
    required this.selectedAsset,
    required this.onAssetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      (AssetClass.forex, 'Forex', Icons.currency_exchange),
      (AssetClass.crypto, 'Crypto', Icons.currency_bitcoin),
      (AssetClass.commodities, 'Commod.', Icons.oil_barrel),
      (AssetClass.indices, 'Indices', Icons.show_chart),
      (AssetClass.stocks, 'Stocks', Icons.business),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (assetClass, label, icon) = filters[index];
          final isSelected = selectedAsset == assetClass;
          return GestureDetector(
            onTap: () => onAssetSelected(assetClass),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD4AF37).withOpacity(0.15)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD4AF37).withOpacity(0.5)
                      : Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 13,
                    color: isSelected
                        ? const Color(0xFFD4AF37)
                        : Colors.white38,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFFD4AF37)
                          : Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
