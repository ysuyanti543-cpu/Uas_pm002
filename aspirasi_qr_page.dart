import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models.dart';

class AspirasiQrPage extends StatelessWidget {
  static const routeName = '/aspirasi-qr';

  final PengajuanLayanan pengajuan;

  const AspirasiQrPage({
    super.key,
    required this.pengajuan,
  });

  @override
  Widget build(BuildContext context) {
    // LINK GOOGLE FORM (QR AKAN MENUJU KE SINI)
    const String googleFormUrl = 'https://forms.gle/ycgo7r98YGfMUvQ76';

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Kode Aspirasi'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: googleFormUrl, // <-- INI YANG MENGHUBUNGKAN QR KE LINK
              size: 220,
            ),
            const SizedBox(height: 16),
            Text('ID: ${pengajuan.id}'),
            Text('Pemohon: ${pengajuan.namaPemohon}'),
            const SizedBox(height: 8),
            const Text(
              'Scan QR untuk membuka Google Form Aspirasi',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(googleFormUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Buka Google Form'),
            ),
          ],
        ),
      ),
    );
  }
}
