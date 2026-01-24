import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr/qr.dart';
import 'package:image/image.dart' as img;

import '../models.dart';
import '../services/firebase_service.dart';
import '../widgets/app_drawer.dart';

const String googleFormUrl = 'https://forms.gle/rUnsiu4t9KWfSJPD7';

class PersetujuanPetugasPage extends StatefulWidget {
  static const routeName = '/persetujuan-petugas';
  const PersetujuanPetugasPage({super.key});
  @override
  State<PersetujuanPetugasPage> createState() =>
      _PersetujuanPetugasPageState();
}

class _PersetujuanPetugasPageState
    extends State<PersetujuanPetugasPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Persetujuan Layanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            tooltip: 'Tampilkan QR Form',
            onPressed: _showFormQrDialog,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate PDF Laporan',
            onPressed: _generatePdf,
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Lihat Laporan Aspirasi',
            onPressed: () => Navigator.of(context).pushNamed('/laporan-aspirasi'),
          ),
        ],
      ),
      body: StreamBuilder<List<PengajuanLayanan>>(
        stream: FirebaseService.instance.streamPengajuan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error?.toString() ?? 'Unknown error'}'));
          }
          final data = snapshot.data ?? [];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.jenisLayanan,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text('Pemohon: ${p.namaPemohon}'),
                      const SizedBox(height: 8),
                      _statusBadge(p.status),
                      const SizedBox(height: 12),
                      _aksiPetugas(p),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= STATUS =================

  Widget _statusBadge(StatusPengajuan status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _aksiPetugas(PengajuanLayanan p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status explanation
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getStatusExplanation(p.status),
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: 8),
        // Action buttons
        Row(
          children: [
            if (p.status == StatusPengajuan.diajukan) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseService.instance.updateStatus(
                          p.id, StatusPengajuan.diproses);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengajuan disetujui! User dapat mengakses QR code.')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating status: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text('Setujui'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    try {
                      await FirebaseService.instance.updateStatus(
                          p.id, StatusPengajuan.ditolak);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengajuan ditolak.')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating status: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text('Tolak'),
                ),
              ),
            ],

            if (p.status == StatusPengajuan.diproses) ...[
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Tampilkan QR'),
                  onPressed: () => _showQrDialog(p),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseService.instance.updateStatus(
                          p.id, StatusPengajuan.selesai);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengajuan diselesaikan!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating status: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text('Selesaikan'),
                ),
              ),
            ],

            if (p.status == StatusPengajuan.ditolak) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    try {
                      await FirebaseService.instance.updateStatus(
                          p.id, StatusPengajuan.diajukan);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Status dikembalikan ke diajukan.')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating status: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text('Kembalikan'),
                ),
              ),
            ],

            if (p.status == StatusPengajuan.selesai) ...[
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Selesai'),
                  onPressed: null, // Disabled
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _getStatusExplanation(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.diajukan:
        return '📝 Status: Menunggu persetujuan petugas. Klik "Setujui" untuk memproses atau "Tolak" jika tidak sesuai.';
      case StatusPengajuan.diproses:
        return '⚡ Status: Sudah disetujui. Klik "Tampilkan QR" agar user dapat mengisi Google Form lengkap.';
      case StatusPengajuan.ditolak:
        return '❌ Status: Ditolak. Klik "Kembalikan" jika ingin memproses ulang.';
      case StatusPengajuan.selesai:
        return '✅ Status: Selesai. User sudah mengisi Google Form dan pengajuan telah selesai diproses.';
    }
  }

  String _statusText(StatusPengajuan s) {
    switch (s) {
      case StatusPengajuan.diajukan:
        return 'Diajukan';
      case StatusPengajuan.diproses:
        return 'Diproses';
      case StatusPengajuan.ditolak:
        return 'Ditolak';
      case StatusPengajuan.selesai:
        return 'Selesai';
    }
  }

  Color _statusColor(StatusPengajuan s) {
    switch (s) {
      case StatusPengajuan.diajukan:
        return Colors.orange;
      case StatusPengajuan.diproses:
        return Colors.blue;
      case StatusPengajuan.ditolak:
        return Colors.red;
      case StatusPengajuan.selesai:
        return Colors.green;
    }
  }

  // ================= QR =================

  void _showFormQrDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR Google Form Aspirasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(_generateFormQrImage()),
            const SizedBox(height: 8),
            const Text(
              'Scan QR untuk membuka Google Form Aspirasi',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showQrDialog(PengajuanLayanan p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR Google Form Aspirasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(_generateQrImage(p)),
            const SizedBox(height: 8),
            const Text(
              'Scan QR untuk membuka Google Form',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Uint8List _generateFormQrImage() {
    final qr = QrCode(4, QrErrorCorrectLevel.L)
      ..addData(googleFormUrl);

    final qrImage = QrImage(qr);
    final image = img.Image(width: 200, height: 200);

    for (int y = 0; y < 200; y++) {
      for (int x = 0; x < 200; x++) {
        final dark = qrImage.isDark(
          y * qr.moduleCount ~/ 200,
          x * qr.moduleCount ~/ 200,
        );
        image.setPixel(
          x,
          y,
          dark
              ? img.ColorRgb8(0, 0, 0)
              : img.ColorRgb8(255, 255, 255),
        );
      }
    }

    return Uint8List.fromList(img.encodePng(image));
  }

  Uint8List _generateQrImage(PengajuanLayanan p) {
    final url =
        '$googleFormUrl?id=${p.id}&source=flutter';

    final qr =
        QrCode(4, QrErrorCorrectLevel.L)
          ..addData(url);

    final qrImage = QrImage(qr);
    final image =
        img.Image(width: 200, height: 200);

    for (int y = 0; y < 200; y++) {
      for (int x = 0; x < 200; x++) {
        final dark = qrImage.isDark(
          y * qr.moduleCount ~/ 200,
          x * qr.moduleCount ~/ 200,
        );
        image.setPixel(
          x,
          y,
          dark
              ? img.ColorRgb8(0, 0, 0)
              : img.ColorRgb8(255, 255, 255),
        );
      }
    }

    return Uint8List.fromList(
        img.encodePng(image));
  }

  // ================= PDF =================

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final snapshot = await FirebaseService.instance.streamPengajuan().first;
    final data = snapshot;

    pdf.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Header(level: 0, child: pw.Text('Laporan Aspirasi')),
          pw.SizedBox(height: 8),
          pw.Text(
            'Catatan: Data lengkap aspirasi tersimpan di Google Form. Data di bawah adalah data awal yang dikirim dari aplikasi.',
            style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
          ),
          pw.SizedBox(height: 8),
          if (data.isEmpty)
            pw.Text('Tidak ada data pengajuan')
          else
            pw.Table.fromTextArray(
              headers: ['ID', 'Jenis', 'Pemohon', 'NIK', 'Keterangan Awal', 'Tanggal', 'Status', 'Form Status'],
              data: data
                  .map((p) => [
                        p.id,
                        p.jenisLayanan,
                        p.namaPemohon,
                        p.nik,
                        p.keterangan.length > 50 ? '${p.keterangan.substring(0, 50)}...' : p.keterangan,
                        p.tanggal.toString().split(' ')[0], // Only date part
                        _statusText(p.status),
                        p.status == StatusPengajuan.diajukan ? 'Belum Diproses' :
                        p.status == StatusPengajuan.diproses ? 'Sedang Diproses' :
                        p.status == StatusPengajuan.ditolak ? 'Ditolak' :
                        'Selesai - Form Sudah Diisi',
                      ])
                  .toList(),
            ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Link Google Form untuk data lengkap: $googleFormUrl',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.blue),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Petunjuk:',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            '• Status "Belum Diproses": Pengajuan baru, belum ada tindakan petugas',
            style: pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            '• Status "Sedang Diproses": Petugas sudah memproses, user dapat mengisi form',
            style: pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            '• Status "Ditolak": Pengajuan ditolak oleh petugas',
            style: pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            '• Status "Selesai - Form Sudah Diisi": Pengajuan selesai dan form sudah diisi user',
            style: pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
    );
  }
}
