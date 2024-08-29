import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk Firestore, digunakan untuk mengambil data dari koleksi.
import 'package:flutter/material.dart'; // Import untuk widget dan tema Material Design.
import 'package:flutter/widgets.dart'; // Import untuk widget dasar.
import 'package:intl/intl.dart'; // Import untuk format tanggal.

class ExistingDataScreen extends StatelessWidget {
  final String nik; // Variabel untuk menyimpan NIK yang diterima dari parameter konstruktor.

  // Konstruktor untuk menerima NIK
  ExistingDataScreen({required this.nik});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF407BFF),
        title: Text('Home Screen', style: TextStyle(color: Colors.white),),      ),
      body: FutureBuilder<DocumentSnapshot>(
        // FutureBuilder digunakan untuk mengambil data dari Firestore secara asynchronous.
        future: FirebaseFirestore.instance
            .collection('pemilihan') // Mengakses koleksi 'pemilihan' di Firestore.
            .where('nik', isEqualTo: nik) // Mencari dokumen dengan NIK yang sama dengan parameter.
            .limit(1) // Membatasi hasil pencarian hanya satu dokumen.
            .get() // Mendapatkan query snapshot dari koleksi.
            .then((snapshot) => snapshot.docs.first), // Mengambil dokumen pertama dari snapshot.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika koneksi masih menunggu data
            return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat menunggu data.
          }
          if (snapshot.hasError) {
            // Jika ada error saat mengambil data
            return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan pesan error.
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            // Jika tidak ada data atau data tidak ditemukan
            return Center(child: Text('Data tidak ditemukan')); // Menampilkan pesan bahwa data tidak ditemukan.
          }

          final data = snapshot.data!.data() as Map<String, dynamic>; // Mengambil data dokumen dan mengonversinya menjadi Map.
          return Padding(
            padding: const EdgeInsets.all(16.0), // Padding untuk seluruh konten.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Menyusun elemen secara horizontal di sebelah kiri.
              children: <Widget>[
                Text('NIK: ${data['nik']}'), // Menampilkan NIK
                Text('Nama: ${data['nama']}'), // Menampilkan Nama
                Text('No HP: ${data['no_hp']}'), // Menampilkan No HP
                Text('Jenis Kelamin: ${data['jenis_kelamin']}'), // Menampilkan Jenis Kelamin
                Text(
                  'Tanggal: ${DateFormat('yyyy-MM-dd').format((data['tanggal'] as Timestamp).toDate())}',
                  // Menampilkan Tanggal dalam format yyyy-MM-dd setelah mengonversi Timestamp ke Date.
                ),
                Text('Alamat: ${data['alamat']}'), // Menampilkan Alamat
                if (data['foto'] != null)
                  Image.network(data['foto']), // Menampilkan gambar jika URL foto ada.
              ],
            ),
          );
        },
      ),
    );
  }
}
