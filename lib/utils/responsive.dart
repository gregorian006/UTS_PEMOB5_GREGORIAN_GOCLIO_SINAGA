import 'package:flutter/widgets.dart';

/// Ukuran UI dihitung proporsional terhadap layar, bukan angka piksel tetap.
extension Responsive on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Tablet, ponsel landscape, atau browser: pakai tata letak dua kolom.
  bool get isWide => screenSize.width >= 720;

  /// Basis skala = sisi terpendek layar, dibatasi agar tidak raksasa di tablet/web.
  double get _base => screenSize.shortestSide.clamp(320.0, 640.0);

  /// Ukuran relatif, mis. `context.rs(0.05)` = 5% dari basis layar.
  double rs(double fraction) => _base * fraction;
}
