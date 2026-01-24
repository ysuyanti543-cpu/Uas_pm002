import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String googleFormUrl = 'https://forms.gle/rUnsiu4t9KWfSJPD7';

class AspirasiQrScannerPage extends StatefulWidget {
  static const routeName = '/aspirasi-qr-scan';
  const AspirasiQrScannerPage({super.key});

  @override
  State<AspirasiQrScannerPage> createState() => _AspirasiQrScannerPageState();
}

class _AspirasiQrScannerPageState extends State<AspirasiQrScannerPage> {
  @override
  void initState() {
    super.initState();
    _openGoogleForm();
  }

  Future<void> _openGoogleForm() async {
    await launchUrl(
      Uri.parse(googleFormUrl),
      mode: LaunchMode.externalApplication,
    );

    // Navigate to Aspirasi Report page to show all submissions
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/laporan-aspirasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
