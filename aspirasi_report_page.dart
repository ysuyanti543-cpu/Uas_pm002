import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../services/mock_service.dart';

class AspirasiReportPage extends StatelessWidget {
  static const routeName = '/laporan-aspirasi';
  const AspirasiReportPage({super.key});

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    final data = MockService.instance.getPengajuan();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Laporan Aspirasi')),
          pw.SizedBox(height: 8),
          pw.Table.fromTextArray(
            headers: ['ID', 'Jenis', 'Pemohon', 'NIK', 'Keterangan', 'Tanggal', 'Status'],
            data: data
                .map((p) => [
                      p.id,
                      p.jenisLayanan,
                      p.namaPemohon,
                      p.nik,
                      p.keterangan,
                      p.tanggal.toString(),
                      p.status.toString().split('.').last,
                    ])
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Aspirasi')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generate & Print PDF'),
          onPressed: () async {
            await Printing.layoutPdf(onLayout: (format) => _buildPdf(format));
          },
        ),
      ),
    );
  }
}
