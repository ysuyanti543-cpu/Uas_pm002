import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/mock_service.dart';
import '../models.dart';
import 'aspirasi_qr_page.dart';

class AspirasiQrScannerPage extends StatefulWidget {
  static const routeName = '/aspirasi-qr-scan';
  const AspirasiQrScannerPage({super.key});

  @override
  State<AspirasiQrScannerPage> createState() => _AspirasiQrScannerPageState();
}

class _AspirasiQrScannerPageState extends State<AspirasiQrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePayload(String payload) async {
    if (_scanned) return;
    _scanned = true;

    // 🔹 JIKA QR BERISI LINK (GOOGLE FORM)
    if (payload.startsWith('http')) {
      final uri = Uri.parse(payload);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      _scanned = false;
      return;
    }

    // 🔹 JIKA QR BERISI ID ASPIRASI (MODE LAMA)
    final all = MockService.instance.getPengajuan();
    PengajuanLayanan? found;

    try {
      found = all.firstWhere((p) => p.id == payload);
    } catch (_) {
      found = null;
    }

    if (found != null) {
      _controller.stop();
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => AspirasiQrPage(pengajuan: found!),
          ))
          .then((_) {
        _scanned = false;
        _controller.start();
      });
      return;
    }

    // 🔹 JIKA TIDAK DIKENALI
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR tidak dikenali'),
        content: Text(payload),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _scanned = false;
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pindai QR Aspirasi')),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final raw = barcode.rawValue;
          if (raw != null && raw.isNotEmpty) {
            _handlePayload(raw);
          }
        },
      ),
    );
  }
}
