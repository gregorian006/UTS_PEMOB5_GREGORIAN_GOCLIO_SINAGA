import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'app_button.dart';

/// Ditampilkan bila halaman dibuka tanpa kuis aktif (mis. refresh di browser).
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.rs(0.08)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_empty_rounded,
                  size: context.rs(0.2), color: Theme.of(context).colorScheme.primary),
              SizedBox(height: context.rs(0.04)),
              Text('Belum ada kuis yang berjalan',
                  style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              SizedBox(height: context.rs(0.06)),
              AppButton(
                label: 'Ke Beranda',
                icon: Icons.home_rounded,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
