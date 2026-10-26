import 'package:flutter/material.dart';

import '../utils/responsive.dart';

/// Pembungkus halaman: bisa di-scroll (anti overflow) dan lebarnya dibatasi
/// agar tetap proporsional di tablet maupun browser.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child, this.maxWidthFactor = 1.8});

  final Widget child;
  final double maxWidthFactor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.rs(0.05)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.rs(maxWidthFactor)),
            child: child,
          ),
        ),
      ),
    );
  }
}
