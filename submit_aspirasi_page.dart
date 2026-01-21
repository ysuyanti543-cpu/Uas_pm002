import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/mock_service.dart';
import '../models.dart';
import 'aspirasi_qr_page.dart';

const String googleFormUrl = 'https://forms.gle/ycgo7r98YGfMUvQ76';

class SubmitAspirasiPage extends StatefulWidget {
  static const routeName = '/submit-aspirasi';
  const SubmitAspirasiPage({super.key});

  @override
  State<SubmitAspirasiPage> createState() => _SubmitAspirasiPageState();
}

class _SubmitAspirasiPageState extends State<SubmitAspirasiPage> {
  final _formKey = GlobalKey<FormState>();
  final _jenisCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _keteranganCtrl = TextEditingController();

  @override
  void dispose() {
    _jenisCtrl.dispose();
    _namaCtrl.dispose();
    _nikCtrl.dispose();
    _keteranganCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kirim Aspirasi')),
      drawer: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _jenisCtrl,
                decoration: const InputDecoration(labelText: 'Jenis Aspirasi'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan jenis aspirasi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Pemohon'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan nama' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nikCtrl,
                decoration: const InputDecoration(labelText: 'NIK'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan NIK' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _keteranganCtrl,
                decoration: const InputDecoration(labelText: 'Keterangan'),
                validator: (v) => (v ?? '').isEmpty ? 'Masukkan keterangan' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Kirim Aspirasi & Tampilkan QR'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    MockService.instance.addPengajuan(
      _jenisCtrl.text.trim(),
      _namaCtrl.text.trim(),
      _nikCtrl.text.trim(),
      _keteranganCtrl.text.trim(),
    );

    final all = MockService.instance.getPengajuan();
    final created = all.isNotEmpty ? all.last : null;
    if (created != null) {
      // Open Google Form link directly
      final uri = Uri.parse(googleFormUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      // show a SnackBar with action to view QR
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Aspirasi terkirim, Google Form dibuka'),
          action: SnackBarAction(
            label: 'Lihat QR',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AspirasiQrPage(pengajuan: created),
              ));
            },
          ),
        ),
      );
      // optionally clear the form for next input
      _jenisCtrl.clear();
      _namaCtrl.clear();
      _nikCtrl.clear();
      _keteranganCtrl.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuat aspirasi')));
    }
  }
}
