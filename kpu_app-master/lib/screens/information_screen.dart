import 'package:flutter/material.dart'; // Import untuk widget dan tema Material Design.

class InformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF407BFF),
        title: Text(
          'Informasi Pemilihan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0), // Padding di seluruh sisi ListView
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0), // Padding vertikal di sekitar header
            child: Center(
              child: Text(
                'Informasi Pemilihan KPU', // Judul utama yang ditampilkan di tengah header
                style: TextStyle(
                  fontSize: 28, // Ukuran font untuk header
                  fontWeight: FontWeight.bold, // Menebalkan font header
                  color: Color(0xFF407BFF), // Warna header sesuai dengan warna primer
                ),
              ),
            ),
          ),

          // Overview
          _buildSection(
            title: 'Tentang Pemilihan',
            content: 'Pemilihan Umum (Pemilu) adalah proses demokrasi di mana rakyat memilih perwakilan mereka untuk duduk di berbagai badan pemerintahan. Proses ini penting untuk memastikan bahwa suara rakyat didengar dan diperhitungkan.',
          ),
          
          // Election Dates
          _buildSection(
            title: 'Tanggal Pemilihan',
            content: 'Tanggal pemilihan umum adalah sebagai berikut:\n\n'
                '1. Pemilihan Presiden: 14 Februari 2024\n'
                '2. Pemilihan Legislatif: 14 Februari 2024\n'
                '3. Pemilihan Kepala Daerah: 14 Maret 2024',
          ),
          
          // How to Vote
          _buildSection(
            title: 'Cara Memilih',
            content: 'Untuk memilih, Anda harus terdaftar sebagai pemilih. Berikut adalah langkah-langkah untuk memilih:\n\n'
                '1. Verifikasi pendaftaran Anda di situs resmi KPU.\n'
                '2. Datang ke tempat pemungutan suara (TPS) sesuai jadwal.\n'
                '3. Bawa identitas diri yang sah.\n'
                '4. Ikuti petunjuk dari petugas TPS untuk memberikan suara.',
          ),
          
          // Voter Registration
          _buildSection(
            title: 'Pendaftaran Pemilih',
            content: 'Jika Anda belum terdaftar sebagai pemilih, Anda dapat mendaftar melalui:\n\n'
                '1. Website resmi KPU.\n'
                '2. Kantor Kecamatan terdekat.\n'
                '3. Melalui aplikasi pendaftaran pemilih online.',
          ),
          
          // Important Links
          _buildSection(
            title: 'Tautan Penting',
            content: 'Berikut adalah beberapa tautan penting terkait pemilihan:\n\n'
                '- [Website Resmi KPU](https://www.kpu.go.id)\n'
                '- [Informasi Pendaftaran Pemilih](https://www.kpu.go.id/pendaftaran)\n'
                '- [Panduan Pemilih](https://www.kpu.go.id/panduan)',
          ),
          
          // Contact Information
          _buildSection(
            title: 'Kontak',
            content: 'Jika Anda memiliki pertanyaan lebih lanjut, silakan hubungi:\n\n'
                'KPU Pusat: (021) 1234567\n'
                'Email: info@kpu.go.id\n'
                'Alamat: Jalan KPU No. 1, Jakarta, Indonesia',
          ),
        ],
      ),
    );
  }

  // Method untuk membangun setiap bagian dengan judul dan konten
  Widget _buildSection({required String title, required String content}) {
    return Card(
      elevation: 4.0, // Bayangan card untuk efek mengangkat
      margin: EdgeInsets.only(bottom: 16.0), // Jarak bawah antara card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Sudut melengkung untuk card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di dalam card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Menyusun elemen secara vertikal dengan rata kiri
          children: [
            Text(
              title, // Judul bagian
              style: TextStyle(
                fontSize: 20, // Ukuran font untuk judul
                fontWeight: FontWeight.bold, // Menebalkan font judul
                color: Color(0xFF407BFF), // Warna judul sesuai dengan warna primer
              ),
            ),
            SizedBox(height: 12), // Jarak vertikal antara judul dan konten
            Text(
              content, // Konten bagian
              style: TextStyle(
                fontSize: 16, // Ukuran font untuk konten
                color: Colors.black87, // Warna font konten yang lebih gelap
              ),
            ),
          ],
        ),
      ),
    );
  }
}
