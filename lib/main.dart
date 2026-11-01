import 'package:flutter/material.dart';
import 'login_page.dart'; // Impor file halaman login Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Aplikasi Saya',
      home: LoginPage(), // MaterialApp menyediakan Directionality dan tema yang dibutuhkan Scaffold!
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormBiodataPage extends StatefulWidget {
  const FormBiodataPage({super.key});

  @override
  State<FormBiodataPage> createState() => _FormBiodataPageState();
}

class _FormBiodataPageState extends State<FormBiodataPage> {
  // GlobalKey untuk mengontrol dan memvalidasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil nilai dari TextFormField
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();

  // Variabel untuk Checkbox (Setuju Syarat & Ketentuan)
  bool _setujuSyarat = false;

  @override
  void dispose() {
    // Bersihkan controller saat widget dihancurkan
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani proses simpan
  void _simpanData() {
    // Validasi form utama
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan untuk Checkbox
      if (!_setujuSyarat) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus menyetujui syarat & ketentuan terlebih dahulu!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Jika validasi sukses dan checkbox dicentang, tampilkan ringkasan via SnackBar
      final ringkasan = 'Data Berhasil Disimpan!\n'
          'Nama: ${_namaController.text}\n'
          'Email: ${_emailController.text}\n'
          'No. HP: ${_noHpController.text}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ringkasan),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Biodata Diri',
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1. TextFormField Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 1. TextFormField Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi!';
                  }
                  if (!value.contains('@')) {
                    return 'Format email tidak valid (harus mengandung "@")';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 1. TextFormField No. HP
              TextFormField(
                controller: _noHpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor HP wajib diisi!';
                  }
                  if (value.length < 10) {
                    return 'Nomor HP minimal harus 10 digit!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Checkbox "Setuju Syarat"
              CheckboxListTile(
                title: const Text('Saya menyetujui syarat dan ketentuan yang berlaku'),
                value: _setujuSyarat,
                onChanged: (bool? value) {
                  setState(() {
                    _setujuSyarat = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // 4. Tombol Simpan
              SizedBox(
                width: double.infinity, // Membuat tombol melebar penuh
                child: ElevatedButton(
                  onPressed: _simpanData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}